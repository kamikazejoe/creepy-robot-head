const cv           = require('opencv');
const Promise      = require('bluebird');
const EventEmitter = require('events');
const _            = require('lodash');

const faceDetectorModels = [
	'./node_modules/opencv/data/haarcascade_frontalface_alt.xml',
	//'./node_modules/opencv/data/haarcascade_frontalface_alt2.xml',
	//'./node_modules/opencv/data/haarcascade_frontalface_alt_tree.xml',
];

const eyeDetectorModels = [
	//'./node_modules/opencv/data/haarcascade_eye.xml',
];

const runModel = (image, model) => {
	return new Promise((resolve, reject) => {
		image.detectObject(model, {}, (err, features) => {
			if (err) {
				reject(err);
			}
			else {
				resolve(features);
			}
		});
	});
}

const runFaceModels = (image) => {
	return Promise.map(faceDetectorModels, (model) => runModel(image, model));
}

const runEyeModels = (image) => {
	return Promise.map(eyeDetectorModels, (model) => runModel(image, model));
}

const findFeatures = (image) => {
	if (image.width() < 1 || image.height() < 1) throw new Error('image has no size');

	return Promise.props({
		faces: runFaceModels(image).then(_.flatten),
		eyes:  runEyeModels(image).then(_.flatten),
	});
}

const runCameraThread = (camera, freq = 250) => {
	const imgEmitter = new EventEmitter();

	const intervalId = setInterval(() => {
		camera.read((err, image) => {
			if (err) {
				clearInterval(intervalId);
				imgEmitter.emit('error', err);
			}
			else {
				imgEmitter.emit('image', image);
			}
		});
	}, freq);

	return imgEmitter;
}

module.exports = class FaceDetector extends EventEmitter {
	constructor() {
		super();

		this.camera = new cv.VideoCapture(1);
		this.window = new cv.NamedWindow('Video', 0);

		this.imgEmitter = runCameraThread(this.camera);

		this.handlingImage = false;

		this.imgEmitter.on('error', (err) => this.emit('error', err));

		this.imgEmitter.on('image', (image) => {
			if (!this.handlingImage) {
				this.handlingImage = true;

				Promise.resolve()
				.then(() => findFeatures(image))
				.then(({faces, eyes}) => {
					if (faces.length > 0) {
						const face = faces[0];
						const screenCenter = [image.width() / 2, image.height() / 2];
						const faceCenter = [face.x + face.width / 2, face.y + face.height / 2];
						const faceVec = [
							(faceCenter[0] - screenCenter[0]) / (image.width() / 2),
							(screenCenter[1] - faceCenter[1]) / (image.height() / 2),
						];

						image.line(screenCenter, faceCenter);
						image.ellipse(
							faceCenter[0], faceCenter[1],
							[face.width / 2, face.height / 2]);

						this.emit('face', faceVec);
					}

					this.window.show(image);
					this.window.blockingWaitKey(0, 50);
				})
				.then(() => this.handlingImage = false);
			}
			else {
				console.log('dropping image');
			}
		});
	}
}

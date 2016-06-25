const servos = require('./servos');
const FaceDetector = require('./face-detector');
const expressions = require('./expressions');
const _ = require('lodash');
const Promise = require('bluebird');

const turnFactor = 1;
const tiltFactor = 1;

const handleError = (msg) => (err) => {
	console.error(msg);
	console.error(require('util').inspect(err, true, null));
	if (err.stack) console.error(err.stack);
	process.exit(1);
}

const randomSearch = (servoCtrl) => {
	console.log('searching for faces');

	return Promise.all([
		servoCtrl.neckTurn(Math.floor(Math.random()*100)),
		servoCtrl.neckTilt(Math.floor(Math.random()*100)),
	]);
}

const centerFace = (servoCtrl, face) => {
	const turnVal = face[0];
	const tiltVal = face[1];

	const neckTurn = servoCtrl.neckTurn();
	const neckTilt = servoCtrl.neckTilt();

	var newNeckTurn = 50+(neckTurn-50)+(50*turnVal*turnFactor);
	var newNeckTilt = 50+(neckTilt-50)+(50*tiltVal*tiltFactor);

	if (newNeckTurn < 0)   newNeckTurn = 0;
	if (newNeckTurn > 100) newNeckTurn = 100;

	if (newNeckTilt < 0)   newNeckTilt = 0;
	if (newNeckTilt > 100) newNeckTilt = 100;

	console.log('current neck turn: '+neckTurn);
	console.log('current neck tilt: '+neckTilt);

	console.log('new neck turn: '+newNeckTurn);
	console.log('new neck tilt: '+newNeckTilt);

	return Promise.all([
		servoCtrl.neckTurn(newNeckTurn),
		servoCtrl.neckTilt(newNeckTilt),
	]);
}

servos()
.then(servoCtrl => {
	const fd = new FaceDetector();

	fd.on('error', handleError('error detecting faces'));

	var handlingFace = false;
	var lastFaceSeen = (new Date).getTime();

	const touchLastFaceSeen = () => lastFaceSeen = (new Date).getTime();
	const timeSinceFaceSeen = () => (new Date).getTime() - lastFaceSeen;

	fd.on('face', (face) => {
		if (!handlingFace) {
			console.log('handling face: '+face);
			handlingFace = true;

			Promise.resolve()
			.then(() => centerFace(servoCtrl, face))
			.then(() => expressions.random(servoCtrl))
			.delay(1000)
			.then(() => expressions.neutral(servoCtrl))
			.then(() => handlingFace = false)
			.then(() => touchLastFaceSeen())
			.catch(handleError('error handling face event'));
		}
		else {
			console.log('dropping face');
		}
	});

	setInterval(() => {
			if ((!handlingFace) && (timeSinceFaceSeen() > 2000)) {
				Promise.resolve()
				.then(() => randomSearch(servoCtrl))
				.then(() => touchLastFaceSeen())
			}
		},
		1000
	);
})
.catch(handleError('serial port error'));

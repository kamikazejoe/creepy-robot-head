const SerialPort = require("serialport").SerialPort;
const printf = require("printf");
const Promise = require("bluebird");
const _ = require('lodash');

const servoDefs = [
	{
		name: 'eyes',
		servos: [0, 1],
		min: 150,
		max: 600,
		position: 50,
		moveTime: 500,
	},
	{
		name: 'eyebrows',
		servos: [2, 3],
		invert: [3],
		min: 150,
		max: 600,
		position: 50,
		moveTime: 500,
	},
	{
		name: 'leftEyebrow',
		servos: [2],
		min: 150,
		max: 600,
		position: 50,
		moveTime: 500,
	},
	{
		name: 'rightEyebrow',
		servos: [3],
		min: 150,
		max: 600,
		position: 50,
		moveTime: 500,
	},
	{
		name: 'jaw',
		servos: [6],
		invert: [6],
		min: 475,
		max: 600,
		position: 50,
		moveTime: 500,
	},
	{
		name: 'neckTurn',
		servos: [8],
		min: 285,
		max: 465,
		position: 50,
		moveTime: 2000,
	},
	{
		name: 'neckTilt',
		servos: [10],
		invert: [10],
		min: 150,
		max: 600,
		position: 50,
		moveTime: 2000,
	},
];

module.exports = () => new Promise((resolve, reject) => {
	const port = new SerialPort("/dev/ttyACM0", {baudRate: 57600});

	servoCtrl = {};

	servoDefs.forEach(def => {
		servoCtrl[def.name] = (pos) => {
			if (_.isNumber(pos)) {
				if (pos < 0 || pos > 100) throw new Error(`invalid position: ${pos}`);

				console.log(`moving servo(s) for ${def.name} to position ${pos}`);

				const distance = Math.abs(pos - def.position);
				const moveTime = (distance/100.0) * def.moveTime;

				def.position = pos;

				const pulses = def.min + (pos/100.0) * (def.max - def.min);
				const invPulses = def.max - (pos/100.0) * (def.max - def.min);

				return Promise.map(def.servos, servo => {
					const realPulses = _.includes(def.invert, servo) ? invPulses : pulses

					const command = printf("M%02d%04d", servo, realPulses);

					console.log(`sending servo command ${command} and waiting ${moveTime} ms`);

					return new Promise((resolve, reject) => {
						port.write(command, (err) => {
							if (err) { reject(err); }
							else     { resolve(); }
						});
					});
				})
				.delay(moveTime)
			}
			else {
				return def.position;
			}
		}
	});

	port.on('open',  () => resolve(servoCtrl));
	port.on('error', (err) => {
		console.error('serial port error');
		console.error(require('util').inspect(err, true, null));
		setTimeout((() => process.exit(1)), 500);
	});
});

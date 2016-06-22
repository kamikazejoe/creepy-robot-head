const servos = require('./servos');

servos()
.then(servoCtrl => {
	return Promise.resolve()
	.then(() => servoCtrl.eyes(50))
	.then(() => servoCtrl.eyes(0))
	.then(() => servoCtrl.eyes(100))
	.then(() => servoCtrl.eyes(50));
})
.then(() => process.exit(0))
.catch(err => {
	console.error('serial port error');
	console.error(require('util').inspect(err, true, null));
	setTimeout((() => process.exit(1)), 500);
});

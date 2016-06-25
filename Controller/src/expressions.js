module.exports = expressions = {
	neutral: (servoCtrl) => {
		console.log('making expression: neutral');

		return Promise.all([
			servoCtrl.eyes(50),
			servoCtrl.eyebrows(50),
			servoCtrl.jaw(0),
		]);
	},

	surprised: (servoCtrl) => {
		console.log('making expression: surprised');

		return Promise.all([
			servoCtrl.eyes(50),
			servoCtrl.eyebrows(100),
			servoCtrl.jaw(100),
		]);
	},

	shifty: (servoCtrl) => {
		console.log('making expression: shifty');

		return Promise.all([
			servoCtrl.eyes(50),
			servoCtrl.eyebrows(50),
			servoCtrl.jaw(0),
		])
		.then(() => servoCtrl.eyes(0))
		.then(() => servoCtrl.eyes(100))
		.then(() => servoCtrl.eyes(0))
		.then(() => servoCtrl.eyes(50));
	},

	random: (servoCtrl) => {
		const expressionNames = Object.keys(expressions);
		const numExpressions = expressionNames.length;
		const randomExpressionNum = Math.floor(Math.random()*numExpressions);
		const randomExpressionName = expressionNames[randomExpressionNum];
		const randomExpression = expressions[randomExpressionName];

		return randomExpression(servoCtrl);
	}
}

#!/usr/bin/env node
//module.exports = require('./src/run');
//
const servos = require('./src/servos');
const expressions = require('./src/expressions.js');

//servos()
//.tap(expressions.neutral)
//.tap(expressions.shifty)
//.tap(expressions.neutral)
//.tap(expressions.surprised)
//.delay(2000)
//.tap(expressions.neutral)

servos()
.tap(servoCtrl => servoCtrl.neckTurn(50))
.delay(100)
.tap(servoCtrl => servoCtrl.neckTurn(0))
.delay(100)
.tap(servoCtrl => servoCtrl.neckTurn(100))
.delay(100)
.tap(servoCtrl => servoCtrl.neckTurn(50))

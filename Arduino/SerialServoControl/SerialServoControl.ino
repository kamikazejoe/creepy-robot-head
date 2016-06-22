#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

char pwmNumStr[3];
char pwmValStr[5];

int pwmNum;
int pwmVal;

void setup() {
  // Initialize Variables
  pwmNumStr[2] = '\0';
  pwmValStr[4] = '\0';

  // Set up the PWM
  pwm.begin();
  pwm.setPWMFreq(60);

  // Start Serial Port
  Serial.begin(57600);
  while (!Serial) {;}
  Serial.println("Goodnight moon!");
}

void loop() {
  if (Serial.available()) {
    if (Serial.read() == 'M') {
      pwmNumStr[0] = Serial.read();
      pwmNumStr[1] = Serial.read();

      pwmNum = atoi(pwmNumStr);

      pwmValStr[0] = Serial.read();
      pwmValStr[1] = Serial.read();
      pwmValStr[2] = Serial.read();
      pwmValStr[3] = Serial.read();

      pwmVal = atoi(pwmValStr);
      
      pwm.setPWM(pwmNum, 0, pwmVal);
      
      Serial.write("Moving servo ");
      Serial.write(itoa(pwmNum, pwmNumStr, 10));
      Serial.write(" to ");
      Serial.write(itoa(pwmVal, pwmValStr, 10));
      Serial.write("\n");
    }
  }
}

// New Robot Head


// Using Adafruit 16-Channel Servo Sheild
#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

// Default address is 0x40
Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();
// call with alternate address by
// Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver(0x41);

// These ranges may changed depending on the servos used.
#define SERVOMIN 150 // minimum pulse length count out of 4096
#define SERVOMAX 600 // maximum pulse length count out of 4096

// servo # counter
uint8_t servonum = 0;

int pulselength;
int degree;

int total_num_servos = 7;

int degreemax = 120;
int degreemin = 20;

int start_signal = 0;
int end_signal = 0;


void setup() {
  

  
  Serial.begin(9600);
  Serial.println("Initializing...");
  
  pwm.begin();
  pwm.setPWMFreq(60); //
  
  pulselength = map(degree, 0, 180, SERVOMIN, SERVOMAX);  // Convert pulselen to degrees
  
  // Set all servos to 90 degrees
  //zero_servos();
  
  // Verify servos are functioning.
  //test_servos();
  
  Serial.println("READY");

}




void test_servos() {
  
  // Drive each servo one at a time
  
  // Swing servo up.
  Serial.print("Testing servo ");
  Serial.println(servonum);
  
  for (degree = degreemin; degree < degreemax; degree++) {
    pwm.setPWM(servonum, 0, pulselength);
  }
  
  delay(500);
  
  
  
  // Swing servo down.
  for (degree = degreemax; degree > degreemin; degree--) {
    pwm.setPWM(servonum, 0, pulselength);
  }
  
  delay(500);
  
  servonum ++; // Move to next servo
  if (servonum > 6) servonum = 0;
}




void zero_servos() {
  
  int servo_loop;
  degree = 90;
  
  for ( servo_loop = 0; servo_loop < total_num_servos; servo_loop) {
    pwm.setPWM(servo_loop, 0, pulselength);
  }

}




void update_servo() {
  
  pwm.setPWM(servonum, 0, pulselength);
  
}  




void loop() {
  
  //test_servos();
  zero_servos();
  
  // If the serial is available, read it.
  while (Serial.available() > 0) 
  {
    start_signal = Serial.peek();
    //Serial.write(start_signal);
    if (start_signal == 114)
    {
      start_signal = Serial.read();
      start_signal = 0;
    }
    else if (start_signal == 91 )
    {
      // Recieve start byte of "["
      start_signal = 0;
      start_signal = Serial.read();
      
      // Servo List
      // ----------
      // 0 - Right Eye
      // 1 - Left Eye
      // 2 - Right Brow
      // 3 - Left Brow
      // 4 - Jaw
      // 5 - Vertical
      // 6 - Horizontal
      
      // All positions in degrees.
      
      // Reads incoming values as integers.
      int right_eye = Serial.parseInt();      // Read right eye position.
      int left_eye = Serial.parseInt();      // Read left eye position.
      
      int right_brow = Serial.parseInt();    // Read right brow position.
      int left_brow  = Serial.parseInt();  // Read left brow position.
      
      int jaw = Serial.parseInt();   // Read jaw position
      
      int vertical = Serial.parseInt();     // Read vertical position.
      int horizontal = Serial.parseInt();   // Read horizontal position.
      
      // Recieve end byte of "]"
      end_signal = Serial.read();
       
    if ( (start_signal == 91) && (end_signal == 93) )
    {
        // Update servo positions
        
        servonum = 0;
        degree = right_eye;
        update_servo();
        
        servonum = 1;
        degree = left_eye;
        update_servo();
        
        servonum = 2;
        degree = right_brow;
        update_servo();
        
        servonum = 3;
        degree = left_brow;
        update_servo();
        
        servonum = 4;
        degree = jaw;
        update_servo();
        
        servonum = 5;
        degree = vertical;
        update_servo();
        
        servonum = 6;
        degree = vertical;
        update_servo();

        
        // Return received input for troubleshooting.
        Serial.write(start_signal);
        Serial.print(right_eye);
        Serial.print(",");
        Serial.print(left_eye);
        Serial.print(",");
        Serial.print(right_brow);
        Serial.print(",");
        Serial.print(left_brow);
        Serial.print(",");
        Serial.print(jaw);
        Serial.print(",");
        Serial.print(vertical);
        Serial.print(",");
        Serial.print(horizontal);
        Serial.write(end_signal);
        Serial.println("");
      }
    }
  }
} 


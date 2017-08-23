//  Active Commutator
// 01.13.15
// WALIII

// Hall sensor controlled active commutator, driven by a servo motor
// Inspired by : who knows?
// 
// Edited by Dan Pollak
#include <Servo.h> 

#define SERVOPIN 10
#define SPEED 20
#define THRES 25
#define GO_HIGH8 8
#define GO_HIGH7 7
#define GO_LOW8 6
#define GO_LOW7 5
#define LEDPIN8 8 //for channel 8 on intan board
#define LEDPIN7 3 //for channel 7 on intan board

Servo myservo;  

int LEFT = 90-SPEED;
int RIGHT = 90+SPEED;
int analogInPin = A0;  
int currSensorValue;        // current value read from hall
int prevSensorValue;        // previoius read from hall
int setpoint = 512;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  //we attach the servo selectively throughout the script.
  pinMode(LEDPIN8, OUTPUT);
  pinMode(LEDPIN7, OUTPUT);
}
//NOTE: LOOP HAS RUNTHROUGH TIME OF ~.5 MILLISECONDS. THIS IS SOMEWHAT SIGNIFICANT.
void loop() {  
  currSensorValue = analogRead(analogInPin);
  
//  Serial.print("sensor = " );                       
//  Serial.println(currSensorValue);      
  
  if(currSensorValue > setpoint + THRES){
    if(!myservo.attached()){myservo.attach(SERVOPIN);} // attach the servo, turn it on

    // need to see if going right or left
    if(prevSensorValue > currSensorValue){
      myservo.write(RIGHT);
    }
    else{myservo.write(LEFT);}
  }
  else if(currSensorValue < setpoint - THRES){
    if(!myservo.attached()){myservo.attach(SERVOPIN);}   

    // need to see if going right or left
    if(prevSensorValue > currSensorValue){
      myservo.write(RIGHT);
    }
    else{myservo.write(LEFT);}
  }
  else {myservo.detach();}

  prevSensorValue = currSensorValue;
//  Serial.println(micros()); //used for testing the time 
  readSerial();
}

void readSerial(){
  //TODO: deal with channel 7 too
  if(Serial.available() > 0){
    int matlabval = Serial.read();
    if(matlabval == GO_HIGH8){
      digitalWrite(LEDPIN8, HIGH);
    }else if(matlabval == GO_HIGH7){
      digitalWrite(LEDPIN7, HIGH);
    }else if(matlabval == GO_LOW8){
      digitalWrite(LEDPIN8, LOW);
    }else if(matlabval == GO_LOW7){
      digitalWrite(LEDPIN7, LOW);
    }
  }
}



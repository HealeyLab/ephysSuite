//  Active Commutator
// 01.13.15
// WALIII

// Hall sensor controlled active commutator, driven by a servo motor
// Inspired by : who knows?
// 
// Edited by Dan Pollak
#include <Servo.h> 

#define SERVOPIN 10
#define SPEED 35
#define THRES 20
#define SETPOINT 512

Servo myservo;  

int LEFT = 90-SPEED;
int RIGHT = 90+SPEED;
int analogInPin = A0;  
int currSensorValue;        // current value read from hall
int prevSensorValue;        // previoius read from hall

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  //we attach the servo selectively throughout the script.
}

void loop() {  
  currSensorValue = analogRead(analogInPin);
  Serial.println(currSensorValue);      
  
  if(currSensorValue > SETPOINT + THRES){
    if(!myservo.attached()){myservo.attach(SERVOPIN);} // attach the servo, turn it on
    turn(-1);
//    Serial.println("left");
  } else if(currSensorValue < SETPOINT - THRES){
    if(!myservo.attached()){myservo.attach(SERVOPIN);}   
    turn(1);
//    Serial.println("right");
  } else {
    myservo.detach();
  }
  delay(200);
  prevSensorValue = currSensorValue;
}

/**
 * reading from hall sensor as you pass it from the left. Code
|               _
|              / \
|             /   \
|_____       /     \________________
|     \     /      
|      \   /        
|       \_/            
|______________________________
*/
void turn(int going_left){
  int curr_speed = 90 + going_left * SPEED;
  while(going_left*(prevSensorValue > currSensorValue)){
    myservo.write(curr_speed);
    currSensorValue = analogRead(analogInPin);
    prevSensorValue = currSensorValue;
  }
  while(going_left * (prevSensorValue < currSensorValue)){
    myservo.write(curr_speed);      
    currSensorValue = analogRead(analogInPin);
    prevSensorValue = currSensorValue;
  }
  while(going_left * (currSensorValue > SETPOINT)){
    myservo.write(curr_speed);      
    currSensorValue = analogRead(analogInPin);
    prevSensorValue = currSensorValue;
  }
  delay(500);
}

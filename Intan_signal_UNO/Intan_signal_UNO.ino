#define GO_HIGH8 8
#define GO_HIGH7 7
#define GO_LOW8 6
#define GO_LOW7 5
#define LEDPIN8 8 //for channel 8 on intan board
#define LEDPIN7 3 //for channel 7 on intan board

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(LEDPIN8, OUTPUT);
//  pinMode(LEDPIN7, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  readSerial();
}

void readSerial(){
  if(Serial.available() > 0){
    int matlabval = Serial.read();
    if(matlabval == GO_HIGH8){
      digitalWrite(LEDPIN8, HIGH);
    }else if(matlabval == GO_LOW8){
      digitalWrite(LEDPIN8, LOW);
    }
//    else if(matlabval == GO_HIGH7){
//       digitalWrite(LEDPIN7, HIGH);
//    }else if(matlabval == GO_LOW7){
//       digitalWrite(LEDPIN7, LOW);
//    }
  }
}

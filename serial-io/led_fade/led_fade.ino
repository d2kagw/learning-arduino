String splitString(String s, char parser,int index);

// LEDs
int ledA = 10;
int ledB = 11;

// Buttons
int buttonA = 12;
int buttonB = 13;

int buttonStateA = 0;
int buttonStateB = 0;

int sloower = 1;

void setup() {
  Serial.begin(9600);
  
  pinMode(ledA, OUTPUT);
  pinMode(ledB, OUTPUT);
  
  pinMode(buttonA, INPUT);
  pinMode(buttonB, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  if (Serial.available()) {
    int rawSerial = Serial.read();
    
    if (rawSerial==500) {
      digitalWrite(ledB, HIGH);
    } else {
      digitalWrite(ledB, LOW);
    }
    
    analogWrite(ledA, rawSerial);
  }
  
  buttonStateA = digitalRead(buttonA);
  if (buttonStateA == HIGH) {
    Serial.print("buttona,");
    Serial.println(buttonStateA);
    delay(sloower);
  };
  
  buttonStateB = digitalRead(buttonB);
  if (buttonStateB == HIGH) {
    Serial.print("buttonb,");
    Serial.println(buttonStateB);
    delay(sloower);
  };
}



String splitString(String s, char parser,int index){
  String rs='\0';
  int parserIndex = index;
  int parserCnt=0;
  int rFromIndex=0, rToIndex=-1;

  while(index>=parserCnt){
    rFromIndex = rToIndex+1;
    rToIndex = s.indexOf(parser,rFromIndex);

    if(index == parserCnt){
      if(rToIndex == 0 || rToIndex == -1){
        return '\0';
      }
      return s.substring(rFromIndex,rToIndex);
    }
    else{
      parserCnt++;
    }

  }
  return rs;
}

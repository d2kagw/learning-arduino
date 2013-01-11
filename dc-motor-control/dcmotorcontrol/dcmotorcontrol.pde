/*
* Controls the speed of a motor using PWM through a H-Bridge.
* Sexy stuff, Will further document in the next few days.
*/

int curspeed = 0;
int fadeAmount = 5;
int limitting = 225;

int PIN_DIR = 10;
int PIN_PWM =  9;

void setup()  {
  pinMode(PIN_DIR, OUTPUT);
  pinMode(PIN_PWM, OUTPUT);
  
  pinMode(buttonPin, INPUT); 
  
  Serial.begin(9600);
} 

void loop()  { 
  digitalWrite(PIN_DIR, HIGH);
  analogWrite(PIN_PWM, curspeed);
  
  curspeed = curspeed + fadeAmount;
  
  Serial.println(curspeed);
  
  if (curspeed == 0 || curspeed == limitting) {
    fadeAmount = -fadeAmount ; 
  }
  
  delay(50);
}


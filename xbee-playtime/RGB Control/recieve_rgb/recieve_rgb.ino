#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(2, 3);

int ledR =  9;
int ledG = 10;
int ledB = 11;

int valueR, valueG, valueB;

//int timeout_counter = 0;
//int timeout_period  = 1000;

void setup() {
  pinMode(ledR, OUTPUT);
  pinMode(ledG, OUTPUT);
  pinMode(ledB, OUTPUT);
  
  Serial.begin(19200);
  Serial.println("Ready to recieve");
  
  mySerial.begin(19200);
}

void loop() {
  // if there's any serial available, read it:
  while (mySerial.available() > 0) {
    // look for the next valid integer in the incoming serial stream:
    valueR = mySerial.parseInt();
    valueG = mySerial.parseInt();
    valueB = mySerial.parseInt();
    
    // look for the newline. That's the end of your sentence:
    if (mySerial.read() == 'e') {
      // fade the red, green, and blue legs of the LED: 
      analogWrite(ledR, valueR);
      analogWrite(ledG, valueG);
      analogWrite(ledB, valueB);
      
      Serial.print(valueR);
      Serial.print(",");
      Serial.print(valueG);
      Serial.print(",");
      Serial.println(valueB);
    }
  }
  
  timeout_counter += 1;
  
}

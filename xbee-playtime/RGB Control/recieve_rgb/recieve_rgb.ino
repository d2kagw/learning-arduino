#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(8, 9);

int ledR = 3;
int ledG = 5;
int ledB = 6;

void setup() {
  pinMode(ledR, OUTPUT);
  pinMode(ledG, OUTPUT);
  pinMode(ledB, OUTPUT);

  Serial.begin(19200);
  while (!Serial) ;
  Serial.println("Ready to recieve");
  
  mySerial.begin(19200);
}

void loop() {
  // if there's any serial available, read it:
  while (mySerial.available() > 0) {
    // look for the next valid integer in the incoming serial stream:
   int red = mySerial.parseInt(); 
   int green = mySerial.parseInt(); 
   int blue = mySerial.parseInt(); 

    // look for the newline. That's the end of your sentence:
    if (mySerial.read() == 'e') {
      // fade the red, green, and blue legs of the LED: 
      analogWrite(ledR,   red);
      analogWrite(ledG, green);
      analogWrite(ledB,  blue);
    }
  }
}









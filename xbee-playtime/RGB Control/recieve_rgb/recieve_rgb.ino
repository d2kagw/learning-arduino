#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(2, 3);

int ledR = 11;
int ledG = 9;
int ledB = 10;

void setup() {
//  pinMode(ledR, OUTPUT);
//  pinMode(ledG, OUTPUT);
//  pinMode(ledB, OUTPUT);

  Serial.begin(19200);

  while (!Serial) ;
  Serial.println("Ready to recieve");

  mySerial.begin(19200);
}

void loop() {
  Serial.println(mySerial.available());
  if (mySerial.available() > 0) {
//      String data = (String)mySerial.read();
//      Serial.println(mySerial.read());
      Serial.println("yep");
//      Serial.print(data);
//      if (data == 1) {
//        digitalWrite(led, HIGH);
//      } else {
//        digitalWrite(led, LOW);
//      }
  }
  delay(100);
}

#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(2, 3);

int ledR = 11;
int ledG = 9;
int ledB = 10;

float r = 0;
float b = 0;
float g = 0;

String rgbData = "";

void setup() {
//  pinMode(ledR, OUTPUT);
//  pinMode(ledG, OUTPUT);
//  pinMode(ledB, OUTPUT);

//  Serial.begin(19200);
  mySerial.begin(19200);
}

void loop()
{
//  analogWrite(ledR, abs(sin(r)*255.0));
//  analogWrite(ledG, abs(sin(g)*255.0));
//  analogWrite(ledB, abs(sin(b)*255.0));
  rgbData = String("a");
//  rgbData = rgbData + (int)abs(sin(r)*255.0) + "," + (int)abs(sin(g)*255.0) + "," + (int)abs(sin(b)*255.0);

//  Serial.println(rgbData);
  mySerial.print(rgbData);

  r = r + 0.01;
  g = g + 0.02;
  b = b + 0.03;

  delay(100);
}

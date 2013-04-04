#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(2, 3);

int ledR = 11;
int ledG = 9;
int ledB = 10;

float r = 0.5;
float b = 0;
float g = 0;

String d1;
int rData, gData, bData;

void setup() {
  Serial.begin(19200);
  mySerial.begin(19200);
}

void loop() {
  r = r + 0.01;
  g = g + 0.02;
  b = b + 0.03;

  rData = (int)abs(sin(r)*255.0);
  gData = (int)abs(sin(g)*255.0);
  bData = (int)abs(sin(b)*255.0);

  d1  = String(rData);
  d1 += ",";
  d1 += String(gData);
  d1 += ",";
  d1 += String(bData);
  d1 += "e";

  Serial.println(d1);
  mySerial.print(d1);

  delay(5);
}

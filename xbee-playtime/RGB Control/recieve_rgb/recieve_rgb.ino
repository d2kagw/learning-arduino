#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(2, 3);

int ledR =  9;
int ledG = 10;
int ledB = 11;

int valueR, valueG, valueB;

int timeout_counter = 0;
int timeout_period  = 5000;

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
      // set the LEDs
      setLED(valueR, valueG, valueB);
      
      // reset the timeout manager
      timeout_counter = 0;
    }
  }
  
  // manage timeouts
  timeout_counter += 1;
  if (timeout_counter > timeout_period) {
    Serial.println("We've reached the timeout");
    
    valueR += 1;
    valueG += 1;
    valueB += 1;
    setLED(valueR, valueG, valueB);
  } 
}

void setLED(int r, int g, int b) {
  // constrain
  r = constrain(r, 0, 255);
  g = constrain(g, 0, 255);
  b = constrain(b, 0, 255);
  
  // fade the red, green, and blue legs of the LED: 
  analogWrite(ledR, r);
  analogWrite(ledG, g);
  analogWrite(ledB, b);
  
  // A little 
  Serial.print(r);
  Serial.print(",");
  Serial.print(g);
  Serial.print(",");
  Serial.println(b);
}

#include <SoftwareSerial.h>
SoftwareSerial mySerial =  SoftwareSerial(2, 3);

// LED pins
int ledR = 11;
int ledG = 10;
int ledB =  9;

// RGB Calculated Values
int valueR, valueG, valueB;

// if we loose comms with the host, fade out after timeout_period
unsigned long timeout_period  = 1000.0;
unsigned long timeout_last_reset = millis();
boolean faded_out;

// set to true if you want to see action on the Serial output
boolean logging = true;

// setup
void setup() {
  // setup pins
  pinMode(ledR, OUTPUT);
  pinMode(ledG, OUTPUT);
  pinMode(ledB, OUTPUT);
  
  // test pattern
  testPattern();
  
  // setup serial comms
  if (logging) {
    Serial.begin(9600);
    Serial.println("Ready to recieve");
  }
  mySerial.begin(9600);
  mySerial.println("Ready");
}

// loop
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
      timeout_last_reset = millis();
    }
  }
  
  // manage timeouts
  faded_out = (valueR + valueG + valueB) = 0;
  if (((timeout_last_reset + timeout_period) < millis()) && !faded_out) {
    if (logging) {
      Serial.println("We've reached the timeout");
    }
    
    // fade out & constrain
    valueR = constrain(valueR-1, 0, 255);
    valueG = constrain(valueG-1, 0, 255);
    valueB = constrain(valueB-1, 0, 255);
    
    // set the LEDs
    setLED(valueR, valueG, valueB);
    
    // slow down the fade
    delay(10);
  }
}

// test pattern
void testPattern() {
  setLED(255,0,0);
  delay(500);
  setLED(0,255,0);
  delay(500);
  setLED(0,0,255);
  delay(500);
  setLED(0,0,0);
}

// set the LED colours
void setLED(int r, int g, int b) {
  // My LEDs are common-cathode, so big number = low light
  analogWrite(ledR, map(r, 0, 255, 255, 0));
  analogWrite(ledG, map(g, 0, 255, 255, 0));
  analogWrite(ledB, map(b, 0, 255, 255, 0));
  
  // output the current versions
  if (logging) {
    Serial.print(valueR);
    Serial.print(" - ");
    Serial.print(valueG);
    Serial.print(" - ");
    Serial.println(valueB);
  }
}

/*
  Beat Detector v2
  
  Uses a push button to detect the beat through a users tapping rhythm.
  The code records the tap intervals and calculates the BPM, flashing an LED to the beat.
  
  Version one can be found here:
  https://github.com/d2kagw/learning-arduino/tree/master/beat-detector
  
  Major differences between v1 and v2 are:
  * simplified user input (one button instead of two)
  * simplified code through libraries (for BPM and Button Pressing)
  
  Details on the circuit can be found here:
  https://github.com/d2kagw/learning-arduino/tree/master/beat-detector-v2
  
  Created 1/1/11 by Aaron Wallis
*/

// pins
int ledBeat      = 4;
int ledStatus    = 3;
int buttonTap    = 5;

void setup() {
  Serial.begin(9600);
  
  pinMode(ledBeat,   OUTPUT);
  pinMode(ledStatus, OUTPUT);
  pinMode(buttonTap, INPUT);
};

void loop() {

};


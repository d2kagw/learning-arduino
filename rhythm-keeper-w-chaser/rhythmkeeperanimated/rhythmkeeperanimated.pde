/*
  Rhythm Keeper, previously known as the Beat Detector
  
  Uses a push button to detect the beat through the users tapping rhythm.
  The code records the tap intervals and calculates the BPM, flashing an LED to the beat.
  
  It uses two libraries:
  1. http://github.com/d2kagw/arduino-tap-library/
  2. http://github.com/d2kagw/arduino-rhythm-library/ - of which this is the example.
  
  The original Beat Detector can be found here:
  http://learning-arduino.tumblr.com/post/2558360094/beat-detector-v1
  
  Major differences between v1 and v2 are:
  * simplified user input (one button instead of two)
  * simplified code through libraries (for BPM and Button Pressing)
  
  Details on the circuit can be found here:
  https://github.com/d2kagw/learning-arduino/tree/master/rhythm-keeper
  
  Created 2/1/11 by Aaron Wallis
*/

#include <Tap.h>
#include <Rhythm.h>

int      button = 10;
int     ledBeat = 9;
int   ledStatus = 8;
int  serialData = 2;
int serialClock = 3;
int serialLatch = 4;

int FUL_BEAT = 0;
int HLF_BEAT = 1;
int QTR_BEAT = 2;

#import "patterns"
int pattern_index = 0;
int pattern_count = sizeof(patterns) / 2;

// you can change this value to give you more or fewer taps to listen to
int requiredTaps = 10;
int offset = -5;

// setup the Tap & Rhythm library
Tap tapper(button);
Rhythm beater;

void setup () {
  Serial.begin(9600);
  
  // setup the LED pins
  pinMode(   ledStatus, OUTPUT);
  pinMode(     ledBeat, OUTPUT);
  pinMode(  serialData, OUTPUT);
  pinMode( serialClock, OUTPUT);
  pinMode( serialLatch, OUTPUT);
};

// internal vars
boolean _isListening = false;
boolean _isFirst     = false;
    int _tapCount    = 0;
    int _clock       = 0;

void loop() {
  // turn off the beat light
  digitalWrite(ledBeat, LOW);
  
  // call the loop_timer, that's where the magic happens
  loop_timer();
  
  // a delay is required for the timing to work correctly.
  // not entirely sure why this is the case,
  // maybe someone smarter than I could explain?
  delay(5);
}

// called when a beat occurs
void beat(int size) {
  digitalWrite(ledBeat, HIGH);
  
  digitalWrite(serialLatch, LOW);
  shiftOut(serialData, serialClock, MSBFIRST, patterns[pattern_index*2]);
  digitalWrite(serialLatch, HIGH);
  
  pattern_index ++;
  if (pattern_index > pattern_count) pattern_index = 0;
}

// Where all the Rhythm detection and rhythm management occurs
void loop_timer() {
  // if the button is down...
  if (tapper.isHit()) {
    // and we're not currently counting taps
    if (_isListening == false) {
      // start counting taps
      _isListening = _isFirst = true;
      _tapCount = 0;
      
      // turn on the status light so the user knows we're expecting input
      digitalWrite(ledStatus, HIGH);
      Serial.println("Listening");
    
    // if we are already counting taps
    } else {
      
      // and this is the first tap
      if (_isFirst) {
        // reset the rhythm library
        beater.reset();
        _isFirst = false;
        
        digitalWrite(ledBeat, HIGH);
        Serial.println("first tap");
      
      // if it's not the first tap
      } else {
        
        // record the tap in the library
        beater.tap();
        
        digitalWrite(ledBeat, HIGH);
        Serial.println("tap");
      }
      
      // increment out counter
      _tapCount ++;
    }
  };
  
  // have we reached our tap count?
  if (_tapCount > requiredTaps && _isListening) {
    // stop listening and turn off the status LED
    _isListening = false;
    digitalWrite(ledStatus, LOW);
  }
  
  // if we're in blinking mode and our timing is set
  if (!_isListening && beater.currentTiming != 0) {
    if (_clock >= (beater.currentTiming)) {
      beat(FUL_BEAT);
      _clock = 0;
    } else if (_clock >= (beater.currentTiming / 2)) {
      beat(HLF_BEAT);
    } else if (_clock >= (beater.currentTiming / 4) || _clock >= (beater.currentTiming / 4) * 2 || _clock >= (beater.currentTiming / 4) * 3) {
      beat(QTR_BEAT);
    }
    _clock ++;
  }
  
  // if we're listening, hit the loop
  if (_isListening) beater.loop();
};



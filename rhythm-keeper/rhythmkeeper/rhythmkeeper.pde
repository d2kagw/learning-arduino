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
    
    int    button = 5;
    int   ledBeat = 4;
    int ledStatus = 3;
    
    // you can change this value to give you more or fewer taps to listen to
    int requiredTaps = 10;
    
    // setup the Tap & Rhythm library
    Tap tapper(button);
    Rhythm beater;
    
    void setup () {
      Serial.begin(9600);
      
      // setup the LED pins
      pinMode( ledStatus, OUTPUT);
      pinMode(   ledBeat, OUTPUT);
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
    void beat() {
      digitalWrite(ledBeat, HIGH);
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
        // and we're on a beat
        if ( _clock >= beater.currentTiming) {
          // call the beat method
          beat();
          
          // reset the clock
          _clock = 0;
        }
        _clock ++;
      }
      
      // if we're listening, hit the loop
      if (_isListening) beater.loop();
    };
    
    

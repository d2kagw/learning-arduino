## Rhythm Keeper

<object width="600" height="362"><param name="movie" value="http://www.youtube.com/v/npFyAivyuIA?fs=1&amp;hl=en_US&amp;rel=0&amp;hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/npFyAivyuIA?fs=1&amp;hl=en_US&amp;rel=0&amp;hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="600" height="362"></embed></object>

Yesterday I posted the details for a [Beat Detector](http://learning-arduino.tumblr.com/post/2558360094/beat-detector-v1). It was quite a rough prototype, but it did the job.

Two things I really wanted to change were the code (it was a complete mess) and I wanted to remove one of the buttons, since it wasn't really needed.

As part of this project I've released two Arduino Libraries:

1. [Rhythm Library](http://github.com/d2kagw/arduino-rhythm-library): which manages the timing and event firing
2. [Tap Library](http://github.com/d2kagw/arduino-tap-library): ensures when a button is pressed, you only receive one event.

I'll be releasing a more complex version of this prototype tomorrow which will incorporate proper animation of LEDs using the Rhythm library, but this should be a good starting point for anyone who wants to use variable beat/event based triggers.

## What you'll need

* Arduino Uno
* Breadboard
* 5x Jumper Wires
* 2x LEDs (of different colours)
* 1x breadboard mountable button
* 2x 330&#8486; resistors (or which ever resistors best suit your LEDs)
* 1x 10k&#8486; resistors

**Note:** almost all the projects I put together use the [SparkFun Arduino UNO Inventors Kit](http://www.sparkfun.com/products/10173) and [SparkFun Beginner Parts Kit](http://www.sparkfun.com/products/10003) which you can buy at [ToysDownUnder.com](http://toysdownunder.com/arduino).

## Sketch
<img src="https://github.com/d2kagw/learning-arduino/raw/master/rhythm-keeper/fritzing.png" width="600px" alt="Rhythm Keeper" title="Rhythm Keeper"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](https://github.com/d2kagw/learning-arduino/raw/master/rhythm-keeper/rhythm-keeper.fz).

## Code

    #include <Tap.h>    // http://github.com/d2kagw/arduino-tap-library/
    #include <Rhythm.h> // http://github.com/d2kagw/arduino-rhythm-library/
    
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

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](https://github.com/d2kagw/learning-arduino/raw/master/rhythm-keeper/rhythmkeeper/rhythmkeeper.pde).

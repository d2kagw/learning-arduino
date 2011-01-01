## Rhythm/Beat Detector v1

<object width="600" height="362"><param name="movie" value="http://www.youtube.com/v/kFgMoDdVyFo?hl=en&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/kFgMoDdVyFo?hl=en&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="600" height="362"></embed></object>

On my quest to build the greatest 3D LED matrix I thought i'd be a good idea to build a beat detector so the animations I eventually program into the project can adjust themselves to the beat of the music.

This is a fairly rough project, I hacked it together in a day, and I was drinking pretty heavily while tinkering (it was New Years Day - stop looking at me like that).
This version requires human input, so you need to hit a button to the rhythm for now.

The code really needs a clean up, but that'll come in the next few days.

## What you'll need

* Arduino Uno
* Breadboard
* 6x Jumper Wires
* 2x LEDs (of different colours)
* 2x breadboard mountable buttons
* 2x 330&#8486; resistors (or which ever resistors best suit your LEDs)
* 2x 10k&#8486; resistors

**Note:** almost all the projects I put together use the [SparkFun Arduino UNO Inventors Kit](http://www.sparkfun.com/products/10173) and [SparkFun Beginner Parts Kit](http://www.sparkfun.com/products/10003) which you can buy at [ToysDownUnder.com](http://toysdownunder.com/arduino).

## Sketch
<img src="https://github.com/d2kagw/learning-arduino/raw/master/beat-detector/fritzing.png" width="600px" alt="Rhythm/Beat Detector v1" title="Rhythm/Beat Detector v1"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](https://github.com/d2kagw/learning-arduino/raw/master/beat-detector/beatdetector.fz).

## Code

Before we dive into the code, know that it's really rough and also quite hacky.
I'll be releasing a V2 of the beat detector in the coming days that'll come with greatly refactored source.

There's a few reasons for the complexity.
Firstly, because it's an endless event loop, you need to write additional code to handle user events that are only meant to be triggered once - in this case, users clicking a button.
You'll find that almost half the code is managing button states - I'll be releasing a small library to help manage this in the coming days.

    // pins
    int ledBeat      = 4;
    int ledStatus    = 3;
    int buttonListen = 2;
    int buttonTap    = 5;
    
    // change the size of the array to increase accuracy (by requiring more taps)
    int taps[10];
    int requiredTaps = 10;
    
    // refresh speed
    int refresh = 5;
    
    void setup() {
      Serial.begin(9600);
      
      pinMode(ledBeat,   OUTPUT);
      pinMode(ledStatus, OUTPUT);
      
      pinMode(buttonListen, INPUT);
      pinMode(buttonTap,    INPUT);
    };
    
    boolean _isReset    = false;
    boolean _isCounting = false;
    boolean _hasTapped  = false;
    int     _tapCount   = 0;
    boolean _isDown     = false;
    int     _counter    = 0;
    int     _counterBPM = 0;
    int     _BPM        = 0;
    
    void loop() {
      // get the button status
      int listenStatus = digitalRead(buttonListen);
      int tapStatus    = digitalRead(buttonTap);
      _hasTapped       = false;
      
      // if the status button is down, we reset.
      if (listenStatus == HIGH && _isReset == false) {
        Serial.println("Re-counting");
        _isReset = true;
      }
      
      // if we're reset turn on the 'listening' light
      digitalWrite(ledBeat, LOW);
      if (_isReset) {
        digitalWrite(ledStatus, HIGH);
      } else {
        digitalWrite(ledStatus, LOW);
      }
      
      // is the tap button down?
      if (_isCounting) {
        // is the button down?
        if (tapStatus == HIGH) {
          // is this the first count of the press?
          if (_isDown == false) {
            // turn on the beat LED
            digitalWrite(ledBeat, HIGH);
            
            Serial.print("tap: ");
            Serial.println(_counter * refresh);
            
            // record the time interval
            taps[_tapCount] = _counter * refresh;
            
            // increment the tap count
            _tapCount += 1;
            
            // reset the counter
            _counter = 0;
          }
          
          // we've recorded this tap
          _isDown = true;
          
        } else {
          // turn off the beat LED
          digitalWrite(ledBeat, LOW);
          
          // user has released the tap button, so prepare for another tap
          _isDown = false;
        }
      
      // if it's reset, but not yet counting, start the count cycle
      // this happens on the first tap
      } else if (tapStatus == HIGH && _isReset) {
        _isCounting = true;
        _counter = 0;
        _isDown = true;
      }
      
      // have we got enough taps?
      if (_tapCount >= requiredTaps && _isCounting) {
        Serial.print("Has counted to ");
        Serial.println(_tapCount);
        
        // stop waiting for taps
        _isReset = false;
        _isCounting = false;
        _tapCount = 0;
        
        // turn beat LED off
        digitalWrite(ledBeat, LOW);
        
        // calculate the average time between hits
        int _average = 0;
        for (int tTapIndex = 0; tTapIndex < requiredTaps; tTapIndex++) {
          _average += taps[tTapIndex];
        }
        _average = _average / requiredTaps;
        _BPM = _average;
        
        Serial.print("Average time is ");
        Serial.println(_average);
      }
      
      // if we're blinking to da beat
      if (!_isCounting && !_isReset) {
        // and a `BPM` is set
        if (_BPM != 0) {
          // and the counter matches our `BPM`
          if (_counterBPM >= (_BPM / refresh)) {
            Serial.println("tic");
            
            // blink the light
            digitalWrite(ledBeat, HIGH);
            _counterBPM = 0;
          }
        }
      }
      
      // delay
      delay(refresh);
      
      // counter increment
      if (_isCounting) _counter += 1;
      _counterBPM += 1;
    };

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](https://github.com/d2kagw/learning-arduino/raw/master/beat-detector/beatdetector/beatdetector.pde).

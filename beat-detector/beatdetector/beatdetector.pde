    /*
      Beat Detector v1
      
      Uses a touch sensor input that a user 'taps' to a beat.
      The board code records the tap intervals and calculates the BPM.
      Two lights are on the board:
      * LED1 blinks as you tap
      * LED2 blinks to the calculated beat
      
      Details on the circuit can be found here:
      https://github.com/d2kagw/learning-arduino/tree/master/8-led-chaser  
      
      Created 1/1/11 by Aaron Wallis
    */
    
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
    

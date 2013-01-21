## Serial IO Testing

<!-- <object width="600" height="362"><param name="movie" value="<youtube path>"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="<youtube path>" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="600" height="362"></embed></object> -->

Over the weekend I started playing around with the implementation of the [LiveLight](http://learning-arduino.tumblr.com/search/livelight) project I'm working on.

The most complex part of the project is the communication between the host system (running Processing) and the Arduino responsible for updating the colour/brightness of the LEDs.

I started hacking around with serial communications and quickly realised that sending complex data over serial communications isn't as easy as I had hoped.

In this tutorial we'll setup an Arduino with two buttons and two LEDs.
The Arduino will send data (button presses) to Processing through the USB port, Processing will then take the data and return other data (LED on/off states) back to Arduino.

## What you'll need

* Arduino Uno
* Breadboard
* 2x 10kΩ Resistors
* 2x LEDs
* A Computer with Processing installed & working.

## Sketch
<img src="board.png" width="600px" alt="<project name>" title="<project name>"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](board.fzz).

## Code

Because there's we're testing serial communication, there's two parts to the code:

1. The Arduino Code: sending inputs to the Processing code, and reading the response
2. The Processing Code: retrieving output from the Arduino board, and returning actionable data 

### Arduino Code

    // LEDs
    int ledA = 10;
    int ledB = 11;
    
    // Buttons
    int buttonA = 12;
    int buttonB = 13;
    
    int buttonStateA = 0;
    int buttonStateB = 0;
    
    int sloower = 1;
    
    void setup() {
      Serial.begin(9600);
      
      pinMode(ledA, OUTPUT);
      pinMode(ledB, OUTPUT);
      
      pinMode(buttonA, INPUT);
      pinMode(buttonB, INPUT);
    }
    
    // the loop routine runs over and over again forever:
    void loop() {
      // if we're setup to read data
      if (Serial.available()) {
        // read the response
        int rawSerial = Serial.read();
        
        // if the response == 500
        if (rawSerial==500) {
          // turn on the light
          digitalWrite(ledB, HIGH);
        } else {
          // otherwise, turn it off
          digitalWrite(ledB, LOW);
        }
        
        // fade the light based on the PWM value
        analogWrite(ledA, rawSerial);
      }
      
      // if the button is pressed
      buttonStateA = digitalRead(buttonA);
      if (buttonStateA == HIGH) {
        // send button state
        Serial.print("buttona,");
        Serial.println(buttonStateA);
        delay(sloower);
      };
      
      // if the button is pressed
      buttonStateB = digitalRead(buttonB);
      if (buttonStateB == HIGH) {
        // send button state
        Serial.print("buttonb,");
        Serial.println(buttonStateB);
        delay(sloower);
      };
    }

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](<code path>).

### Processing Code

    import processing.serial.*;
    
    Serial serial;
    int pwmValue;
    int delta;
    
    boolean redOn;
    
    void setup() {
      frameRate(30);
      
      println(Serial.list());
      int serialPortNumber = 6;
      String port = Serial.list()[serialPortNumber];
      serial = new Serial(this, port, 9600);
      serial.bufferUntil('\n');
      
      pwmValue = 0;
      delta = 10;
      
      redOn = false;
    }
    
    void draw() {
      pwmValue = pwmValue + delta;
      if (pwmValue<10) {
        delta = 10;
      }
      if (pwmValue>240) {
        delta = -10;
      }
      
      serial.write(pwmValue);
      
      if (redOn) {
        serial.write(500);
      };
    }
    
    void serialEvent(Serial port) {
      String inString = port.readStringUntil('\n');
       
      inString = trim(inString);
      if (inString != null) {
        inString = trim(inString);
        
        String actionKey = split(inString, ',')[0];
        int  actionValue = int(split(inString, ',')[1]);
        
        println("Arduino says: " + actionKey + " - " + actionValue);
        
        if (actionKey == "buttonb") {
          redOn != redOn;
        };
      }
    }


**Note:** you can download the [Processing](http://www.processing.org) source code from [here](<code path>).

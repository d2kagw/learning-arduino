## Serial IO Testing

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
<img src="https://raw.github.com/d2kagw/learning-arduino/master/serial-io/board.png" width="600px" alt="<project name>" title="<project name>"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](https://raw.github.com/d2kagw/learning-arduino/master/serial-io/board.fzz).

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

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](https://github.com/d2kagw/learning-arduino/tree/master/serial-io).

### Processing Code

    import processing.serial.*;
    
    Serial serial;
    int pwmValue;
    int delta;
    
    boolean redOn;
    
    void setup() {
      frameRate(30);
      
      println(Serial.list());
      
      // XXXXX
      // You might need to update this port number
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


**Note:** you can download the [Processing](http://www.processing.org) source code from [here](https://github.com/d2kagw/learning-arduino/tree/master/serial-io).

## How to get it running

One thing you'll learn about Serial communications is that it can be really, really touchy.

Everything seems to be A-OK once you get things running, but if one small thing is out of place everything simply won't work and there'll be no explanation for it. So prepare for a fair amount of trial and error.

Firstly, send the code to the Arduino and start it up. At this point of time, nothing should happen.

Then, start the processing app.

**IF** everything is setup A-OK you should see one of your LED's fade up and down indefinitely. If it's not, then we need to slide into debug mode.
First thing to check out is the port the processing code is sending data to.

Have a look at the processing code and look for this line `int serialPortNumber = 6;`. In the Processing log you should see a dump of all the available serial ports. Change that number to match the relevant port (hint: it's the same as the Arduino IDE).

Once changed, try restarting the Processing app. If that doesn't work, then unfortunately, there's not much help I can offer here, just make sure you've followed the instructions above and run through the usual Arduino debug checklist of checking the pin numbers, etc. Then just hack away chunks of code until something works.

One thing that caught me off guard early in the process is the Arduino serial monitor.
If you start throwing `Serial.println()` calls in your code to debug things the serial communication will cease - so keep that in mind.

Should the above sketches work for you then you should have 'two-way' communication between host and client.

## What's next?

I've come across two libraries that can help you pass data between host and client, they take a lot of this off your hands so you can worry about the implementation, but I always like understanding the inner-sanctum before relying on libraries.

* [CmdMessenger](http://playground.arduino.cc/Code/CmdMessenger) which is part of the Arduino Core
* [SerialCommand](https://github.com/kroimon/Arduino-SerialCommand) which looks really hot, but only handles one way communication (or so it seems)

My requirements only include simple data like button states to be passed through so this is essentially the extent of my research... for now!


## Processing and Arduino control via Xbees

I've been learning all about Xbee's as part of a larger Arduino project and recenly "mastered" the art of sending some data from Processing through to an Arduino via two Xbee's.

I won't spend too much time talking about the setting up of Xbee's althoug, I found it much harder than I initially expected (hint: make sure you know the baud rate and use `ATND` to check that the two Xbee's can find each other) but there's a [great tutorial over here](http://www.hughesy.net/wp/arduino/new-easier-xbee-for-mac-lion-os-x-10-7-with-arduino/).

As for the Processing part, well that's easy by comparison.

We'll be generating a very straight forward boilerplate for serial communications between Processing and Arduino.

## What you'll need

* Arduino Uno
* RGB LED
* Jumper Wires
* 2x Xbees (I'm using Series 1 devices)
* 2x [Adafruit Xbee Adapters](http://www.adafruit.com/products/126) - you could swap this out for any sheild, but I found this super easy to get started with
* 1x [USB FTDI cable](http://www.adafruit.com/products/70) - for programming your Xbee's

## Sketch

The implementation consists of two parts, you have one Xbee connected to your computer via the FTDI cable, and the other mounted on a breadboard using this schematic:
<img src="https://github.com/d2kagw/learning-arduino/raw/master/xbee-playtime/processing-control/fritzing.png" width="600px" alt="Xbee LED Control" title="Xbee LED Control"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](https://github.com/d2kagw/learning-arduino/raw/master/xbee-playtime/processing-control/processing-control.fzz).

Processing will use a software serial library to send messages via the Xbee to the Xbee connected to the Arduino. In this case, the message will be the RGB colour we want the LED to be.

One thing to take very clear notice of is the RX and TX pins on the Xbee - if you get this wrong the sketch won't work.

Lets have a look at the code...

## Arduino Code

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
        Serial.print(", ");
        Serial.print(valueG);
        Serial.print(", ");
        Serial.println(valueB);
      }
    }

## Processing Code

    import processing.serial.*;

    Serial xBee;

    void setup()  {
      size(255,255);
      try {
        String serialPort = serialIndexFor("tty.usbserial");
        xBee = new Serial(this, serialPort, 9600);
      } catch (Exception e) {
        println(e);
        exit();
      }
    }

    float r = 0;
    float b = 0;
    float g = 0;
    int rData, gData, bData;

    void draw() {
      r = r + 0.001;
      g = g + 0.002;
      b = b + 0.003;
      
      rData = (int)abs(sin(r)*255.0);
      gData = (int)abs(sin(g)*255.0);
      bData = (int)abs(sin(b)*255.0);
      
      xBee.write(rData + "," + gData + "," + bData + "e");
      
      delay(10);
    }

    String serialIndexFor(String name) throws Exception {
      for ( int i = 0; i < Serial.list().length; i ++ ) {
        String[] part = match(Serial.list()[i], name);
        if (part != null) {
          return Serial.list()[i];
        }
      }
      throw new Exception("Serial port named '" + name + "' could not be found");
    }

Start by programming your Arduino, and remove it from your computer before running the Processing code against the FTDI cable - I had issues with my Mac recognising both at the same time for some reason, I didn't look into the issue since simply disconecting it worked.

Obviously plug the Arduino up to a power source or another USB port (I used my iPhone wall charger).

On initial run the LED should cycle Red, Green & Blue to demonstrate correct wiring, then proceed to take the data from the Xbee.

If nothing happens, make sure the Processing code is running, and that it's pushing data to the correct port. Secondly, check that the Arduino is actually accepting incoming data by looking at the serial monitor logs.

Lastly, if the Arduino doesn't get data from the controller Xbee the LED will slowly fade to black. Which I thought was a nice touch :D

As always, you can find the code on my (Github account)[].
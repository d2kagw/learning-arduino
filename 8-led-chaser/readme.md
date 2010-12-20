## Pattern based 8 LED Chaser

Last night I completed a simple 8 LED Chaser.
The hardware is identical to the Arduino Examples using the [74HC595 Shift Register](http://www.nxp.com/documents/data_sheet/74HC_HCT595.pdf).

Although you can find a very detailed tutorial of the hardware on this [Arduino page](http://www.arduino.cc/en/Tutorial/ShiftOut), I'll go over the basics here.

## What you'll need

* Arduino Uno
* Breadboard (a large one, or perhaps two smaller ones)
* Quite a few Jumper Wires
* 1x 74HC595 Shift Register
* 8x Single Colour LEDs
* 8x 330&#8486; resistors

**Note:** almost all the projects I put together use the [SparkFun Arduino UNO Inventors Kit](http://www.sparkfun.com/products/10173) and [SparkFun Beginner Parts Kit](http://www.sparkfun.com/products/10003) which you can buy at [ToysDownUnder.com](http://toysdownunder.com/arduino).

## Sketch
![8 LED Chaser Sketch/Schematic][schematic]
[schematic]: https://github.com/d2kagw/learning-arduino/raw/master/8-led-chaser/fritzing.png "8 LED Chaser Sketch/Schematic"

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](https://github.com/d2kagw/learning-arduino/raw/master/8-led-chaser/sketch.fz).

## Code

    /*
     8 LED Chaser using Shift Registers
     
     Manages a series of 8 LEDs through a 74HC595 shift register.
     Users can specify animation patterns and timing through a byte array.
     
     Details on the circuit can be found here:
     https://github.com/d2kagw/learning-arduino/tree/master/8-led-chaser
     
     created 21 Dec. 2010
     by Aaron Wallis
    */
    
    // The pin configuration for the shift register.
    int  data = 2;
    int clock = 3;
    int latch = 4;
    
    // the animation sequence for the LED display
    // first column is the LED status in binary form, second column is the timing in milliseconds
    byte patterns[48] = {
      B00000001, 100,
      B00000010, 100,
      B00000100, 100,
      B00001000, 100,
      B00010000, 100,
      B00100000, 100,
      B01000000, 100,
      B10000000, 100,
      B01000000, 100,
      B00100000, 100,
      B00010000, 100,
      B00001000, 100,
      B00000100, 100,
      B00000010, 100,
      B00000001, 100,
      B00011000, 200,
      B00100100, 200,
      B01000010, 200,
      B10000001, 200,
      B01000010, 200,
      B10100101, 200,
      B01011010, 200,
      B00100100, 200,
      B00011000, 200
    };
    
    // variables used for status
    int pattern_index = 0;
    int pattern_count = sizeof(patterns) / 2;
    
    void setup() {
      // setup the serial output if needed
      Serial.begin(9600);
      
      // define the pin modes
      pinMode( data, OUTPUT);
      pinMode(clock, OUTPUT);
      pinMode(latch, OUTPUT);
    }
    
    void loop() {
      // activate the patterns
      digitalWrite(latch, LOW);
      shiftOut(data, clock, MSBFIRST, patterns[pattern_index*2]);
      digitalWrite(latch, HIGH);
      
      // delay for the timing
      delay(patterns[(pattern_index*2) + 1]);
      
      // move to the next animation step
      pattern_index ++;
      
      // if we're at the end of the animation loop, reset and start again
      if (pattern_index > pattern_count) pattern_index = 0;
    }

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from  [here](https://github.com/d2kagw/learning-arduino/raw/master/8-led-chaser/chaser/chaser.pde).

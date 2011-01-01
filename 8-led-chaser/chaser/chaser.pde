/*
 8 LED Chaser using Shift Registers
 
 Manages a series of 8 LEDs through a 74HC595 shift register.
 Users can specify animation patterns and timing through a byte array.
 
 Details on the circuit can be found here:
 https://github.com/d2kagw/learning-arduino/tree/master/8-led-chaser
 
 created 21 Dec. 2010 by Aaron Wallis
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

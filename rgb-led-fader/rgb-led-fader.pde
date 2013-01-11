/*
* Very simple experiment in controling the colour of an RGB LED
*/
int ledPinR =  9;
int ledPinG = 10;
int ledPinB = 11;

void setup() {
  pinMode(ledPinR, OUTPUT);
  pinMode(ledPinG, OUTPUT);
  pinMode(ledPinB, OUTPUT);
}

int   max_intensity = 255;
int   red_intensity = (max_intensity / 3) * 0;
int green_intensity = (max_intensity / 3) * 1;
int  blue_intensity = (max_intensity / 3) * 2;

void loop() {
  red_intensity = red_intensity + 1;
  if (red_intensity > max_intensity) {
    red_intensity = 0;
  }
  
  green_intensity = green_intensity + 1;
  if (green_intensity > max_intensity) {
    green_intensity = 0;
  }
  
  blue_intensity = blue_intensity + 1;
  if (blue_intensity > max_intensity) {
    blue_intensity = 0;
  }
  
  analogWrite(ledPinR, red_intensity);
  analogWrite(ledPinG, green_intensity);
  analogWrite(ledPinB, blue_intensity);
  
  delay(10);
}

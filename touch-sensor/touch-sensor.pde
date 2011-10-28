/*
* Playing around with a touch screen
* trying to get a nice solid input to use as a controller, but it's VERY noisy
* need to buy another touch screen to see if it's the component... or me ;P
*/
int xVal = 0;
int yVal = 0;

int  xLow = 170;
int xHigh = 900 - xLow;
int  yLow = 103;
int yHigh = 960 - yLow;

void setup() {
  Serial.begin(38400);
}

void loop() {
  pinMode( A1, INPUT );
  pinMode( A3, INPUT );
  pinMode( A0, OUTPUT );
  digitalWrite( A0, LOW );
  pinMode( A2, OUTPUT );
  digitalWrite( A2, HIGH );
  xVal = analogRead( 1 );
  xVal = ( ((xVal - xLow) * 1.00) / (xHigh * 1.00) ) * 100;
  xVal = ( xVal < 0 ) ? 0 : xVal;
  xVal = ( xVal > 100 ) ? 100 : xVal;
  
  pinMode( A0, INPUT );
  pinMode( A2, INPUT );
  pinMode( A1, OUTPUT );
  digitalWrite( A1, LOW );
  pinMode( A3, OUTPUT );
  digitalWrite( A3, HIGH );
  yVal = analogRead( 0 );
  yVal = ( ((yVal - yLow) * 1.00) / (yHigh * 1.00) ) * 100;
  yVal = ( yVal < 0 ) ? 0 : yVal;
  yVal = ( yVal > 100 ) ? 100 : yVal;
  
  Serial.print(xVal);
  Serial.print(",");
  Serial.println(yVal);
  
  delay(250);
}

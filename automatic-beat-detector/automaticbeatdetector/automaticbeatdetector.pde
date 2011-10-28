/*
* TODO: needs to be documented
* This fella takes the output of a Electret Mic and an OpAmp and tries to detect rhythm.
* It works ok, but I need to throw in a low-pass filter to try and focus the sensor on the bass vs. loud events
*/
int sensorValue = 0;
float variance = 0.96;

int newHigh = 0;
int counter = 0;

void setup() {
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  
  Serial.begin(9600);
}

void loop() {
  sensorValue = analogRead(A5);
  
  if (sensorValue > newHigh) {
    newHigh = sensorValue * variance;
    counter = 0;
    
    Serial.println("beat");
    digitalWrite(11, HIGH);
  } else {
    Serial.println(" ");
    digitalWrite(11, LOW);
  }
  
  counter = counter + 1;
  if (counter > 50) {
    counter = 0;
    newHigh = newHigh * variance;
  }
  
  delay(1);
}


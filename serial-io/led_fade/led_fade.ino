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
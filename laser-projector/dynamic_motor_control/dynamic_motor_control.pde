/*
  Dynamic Motor Control
  
  This is part of the larger 'Laser Projector' project I'm working on.
  
  The initial version of the projector will be drawing hypotrochoid curves
  using two angled mirrors rotating at various speeds.
  
  To achieve this, I need some software smarts to vary the speed of the two motors
  when a trigger is fired.
  
  For now, I'm just using a random number generator to determine the speed.
  There's absolutely no smarts around patterns, ensuring true randomness or managing transitions,
  no doubt that'll come soon ;P
  
  (nice thing about transitions is since the motors have inertia they gradually adjust to the new speed!)
  
  The hardware for this baby can be found here: http://learning-arduino.tumblr.com/post/12056051296/dc-motor-control
  I've added a simple push button which is the trigger in this implementation.
  
  Created 29/10/11 by Aaron Wallis
*/

// pins
int pin_buttonListen    =  2;
int pin_motor1Direction = 10;
int pin_motor1PWM       =  9;
int pin_motor2Direction =  6;
int pin_motor2PWM       =  5;

// the PWM 'speed' limits
// anything higher (higher number == lower RPM) than 225 and I found
// my motors stopped turning you may want/need to tweak this for your own setup
int speedLimitting = 225;

// returns an INT 'PWM' value for the motors
// the number is randomly selected
int newSpeed() {
  return random(0, speedLimitting);
};

void setup() {
  Serial.begin(9600);
  
  // setup the motor pins
  pinMode(pin_motor1Direction, OUTPUT);
  pinMode(pin_motor1PWM, OUTPUT);
  pinMode(pin_motor2Direction, OUTPUT);
  pinMode(pin_motor2PWM, OUTPUT);
  
  // setup the input pins
  pinMode(pin_buttonListen, INPUT);
  pinMode(pin_buttonListen, INPUT);
  
  // seed the random number generator
  // !!! NOTE: make sure you don't have anything using pin 0 !!!
  randomSeed(analogRead(0));
};

void loop() {
  // no need to manage motor direction
  digitalWrite(pin_motor1Direction, HIGH);
  digitalWrite(pin_motor2Direction, HIGH);
  
  // if the button is pressed
  if (digitalRead(pin_buttonListen) == HIGH) {
    // change the speed of the motors
    Serial.println("Changing speeds");
    analogWrite(pin_motor1PWM, newSpeed());
    analogWrite(pin_motor2PWM, newSpeed());
  };
  
  // slow the loop down a bit
  delay(50);
};


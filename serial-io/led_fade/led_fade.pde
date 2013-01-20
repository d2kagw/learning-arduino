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
  background(0);
  
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




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

// Movement Deltas
static final float DELTA_MAX_ROTATION = 5.0;
static final float DELTA_MAX_X = 10.0;
static final float DELTA_MAX_Y = 10.0;

float moveXDelta;
float moveYDelta;
float moveRDelta;

// Colour
static final color[] ALLOWED_COLORS = { #00aef0, #4be717, #ffdc00, #ed008c };

Rect asd;

void setup(){
  size(640, 480);
  frameRate(30);
  
  resetDeltas();
  
  // draw some squares
  asd = new Rect(10,10);
}

void resetDeltas() {
  // set x, y, r and color deltas
  moveRDelta = random(-DELTA_MAX_ROTATION, DELTA_MAX_ROTATION);
  moveYDelta = random(-DELTA_MAX_Y, DELTA_MAX_Y);
  moveXDelta = random(-DELTA_MAX_X, DELTA_MAX_X);
  
  println("xD: " + moveXDelta + " yD: " + moveYDelta);
}

void draw(){
  background(0);
  noStroke();
  fill(ALLOWED_COLORS[floor(random(0,ALLOWED_COLORS.length))]);
  rect(30, 20, 55, 55);
  
  asd.draw(ALLOWED_COLORS[floor(random(0,ALLOWED_COLORS.length))], moveXDelta, moveYDelta, moveRDelta);
}

void keyPressed() {
  resetDeltas();
}

class Rect {
  float w,h;
  float x;
  float y;
  
  Rect(float iX, float iY) {
    x = iX;
    y = iY;
    h = 30.0;
    w = 30.0;
  }
   
  void draw(color clr, float xD, float yD, float rD) {
    x = x + xD;
    y = y + yD;
    
    stroke(clr);
    fill(clr);
    rect(x, y, w, h);
  } 
   
}


/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/23260*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
/*
* Sound reactive kaleidiscope
 * based on Kaleidoscope by Algirdas Rascius (http://mydigiverse.com).
 * http://www.openprocessing.org/visuals/?visualID=2256
 */
import ddf.minim.*;
import ddf.minim.analysis.*;
  
static final int SCREEN_SIZE = 200;
static final int SIDE = 150;
static final float MAX_TILE_ROTATION_DELTA = 0.02;
static final float MAX_ROTATION_DELTA = 0.008;
static final int AUTO_INITIALIZE_COUNT = 50;
 
PGraphics tile;
ArrayList shapes;
Palette palette;
ShapeGenerator shapeGenerator;
float tileRotation;
float rotation;
float tileRotationDelta;
float rotationDelta;
int nextAutoInitialize;
 
Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

void setup() {
  size(750, 500, P3D);
  colorMode(HSB, TWO_PI, 1, 1);
  noStroke();
  textureMode(NORMALIZED);
  tile = createGraphics(SCREEN_SIZE, SCREEN_SIZE, JAVA2D);
  tile.background(color(0));  
  shapes = new ArrayList();
  frameRate(30);
  minim = new Minim(this);
  song = minim.loadFile("01_07_Irma_Vep.mp3", 2048);
  song.loop();  
    // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(300);  
  bl = new BeatListener(beat, song);

  initialize();

}
 
void initialize() {
  shapes.clear();
  palette = getRandomPalette();
  shapeGenerator = getRandomShapeGenerator();
  tileRotationDelta = random(-MAX_TILE_ROTATION_DELTA, MAX_TILE_ROTATION_DELTA);
  rotationDelta = random(-MAX_ROTATION_DELTA, MAX_ROTATION_DELTA);
  nextAutoInitialize = AUTO_INITIALIZE_COUNT;
}
 
void mousePressed() {
  initialize();
}
 
void keyPressed() {
  initialize();
}
 
void draw() {
  drawTile();
  drawAllTiles();
  boolean isbeat = beat.isSnare() || beat.isKick();
  nextAutoInitialize--;
  if (isbeat && nextAutoInitialize< 0) {
    initialize();
  }
}
 
 void stop()
{
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
 
  super.stop();
}
void drawTile() {
   tile.beginDraw();
   tile.filter(BLUR);
   shapeGenerator.createShapes(shapes, tile, palette);
   for (Iterator i=shapes.iterator(); i.hasNext();) {
     Shape s = (Shape)i.next();
     if (!s.draw(tile)) {
       i.remove();
     }
   }
   tile.endDraw();
}
 
final static float SIN_30 = sin(TWO_PI/12);
final static float COS_30 = cos(TWO_PI/12);
 
void drawAllTiles() {
  tileRotation = (tileRotation + tileRotationDelta + TWO_PI) % TWO_PI;
  rotation = (rotation + rotationDelta + TWO_PI) % TWO_PI;
     
  float tx1 = 0.5+0.49*sin(tileRotation);
  float ty1 = 0.5+0.49*cos(tileRotation);
  float tx2 = 0.5+0.49*sin(tileRotation+TWO_PI/3);
  float ty2 = 0.5+0.49*cos(tileRotation+TWO_PI/3);
  float tx3 = 0.5+0.49*sin(tileRotation+TWO_PI/3*2);
  float ty3 = 0.5+0.49*cos(tileRotation+TWO_PI/3*2);
 
  translate(width/2, height/2);
  scale(SIDE, SIDE);
  rotate(rotation);
   
  for (int y=-2; y<=2; y++) {
    pushMatrix();
    translate(0, y*(1+SIN_30));
    for (int x=-2; x<=2; x++) {
      pushMatrix();
      translate(x*2*COS_30, 0);
      if (abs(y)%2==1) {
        translate(COS_30, 0);
      }
      for (int i=0; i<3; i++) {
        rotate(TWO_PI/3);
        for (int j=0; j<2; j++) {
          scale(-1,1);
          beginShape();
          texture(tile);
          vertex(0, 0, tx1, ty1);
          vertex(0, 1, tx2, ty2);
          vertex(COS_30, SIN_30, tx3, ty3);
          endShape();
        }
      }
      popMatrix();
    }
    popMatrix();
  }
 
}


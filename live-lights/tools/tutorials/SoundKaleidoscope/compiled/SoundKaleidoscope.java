import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import org.tritonus.share.midi.*; 
import org.tritonus.sampled.file.*; 
import javazoom.jl.player.advanced.*; 
import org.tritonus.share.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import org.tritonus.share.sampled.*; 
import javazoom.jl.converter.*; 
import javazoom.spi.mpeg.sampled.file.tag.*; 
import org.tritonus.share.sampled.file.*; 
import javazoom.spi.mpeg.sampled.convert.*; 
import ddf.minim.javasound.*; 
import javazoom.spi.*; 
import org.tritonus.share.sampled.mixer.*; 
import javazoom.jl.decoder.*; 
import processing.xml.*; 
import processing.core.*; 
import org.tritonus.share.sampled.convert.*; 
import ddf.minim.spi.*; 
import ddf.minim.effects.*; 
import javazoom.spi.mpeg.sampled.file.*; 
import ddf.minim.signals.*; 
import javazoom.jl.player.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class SoundKaleidoscope extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/23260*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
/*
* Sound reactive kaleidiscope
 * based on Kaleidoscope by Algirdas Rascius (http://mydigiverse.com).
 * http://www.openprocessing.org/visuals/?visualID=2256
 */


  
static final int SCREEN_SIZE = 200;
static final int SIDE = 150;
static final float MAX_TILE_ROTATION_DELTA = 0.02f;
static final float MAX_ROTATION_DELTA = 0.008f;
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

public void setup() {
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
 
public void initialize() {
  shapes.clear();
  palette = getRandomPalette();
  shapeGenerator = getRandomShapeGenerator();
  tileRotationDelta = random(-MAX_TILE_ROTATION_DELTA, MAX_TILE_ROTATION_DELTA);
  rotationDelta = random(-MAX_ROTATION_DELTA, MAX_ROTATION_DELTA);
  nextAutoInitialize = AUTO_INITIALIZE_COUNT;
}
 
public void mousePressed() {
  initialize();
}
 
public void keyPressed() {
  initialize();
}
 
public void draw() {
  drawTile();
  drawAllTiles();
  boolean isbeat = beat.isSnare() || beat.isKick();
  nextAutoInitialize--;
  if (isbeat && nextAutoInitialize<  0) {
    initialize();
  }
}
 
 public void stop()
{
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
 
  super.stop();
}
public void drawTile() {
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
 
public void drawAllTiles() {
  tileRotation = (tileRotation + tileRotationDelta + TWO_PI) % TWO_PI;
  rotation = (rotation + rotationDelta + TWO_PI) % TWO_PI;
     
  float tx1 = 0.5f+0.49f*sin(tileRotation);
  float ty1 = 0.5f+0.49f*cos(tileRotation);
  float tx2 = 0.5f+0.49f*sin(tileRotation+TWO_PI/3);
  float ty2 = 0.5f+0.49f*cos(tileRotation+TWO_PI/3);
  float tx3 = 0.5f+0.49f*sin(tileRotation+TWO_PI/3*2);
  float ty3 = 0.5f+0.49f*cos(tileRotation+TWO_PI/3*2);
 
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

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  public void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  public void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

//=============================================================================================================
interface Palette {
  public int nextColor();
  public void reset();
}
 
//=============================================================================================================
class RandomPalette implements Palette {
  public int nextColor() {
    return color(random(TWO_PI), random(1), random(1));
  }
   
  public void reset() {
  }
}
 
//=============================================================================================================
class RandomBrightPalette implements Palette {
  public int nextColor() {
    return color(random(TWO_PI), 1, 1);
  }
   
  public void reset() {
  }
}
 
//=============================================================================================================
class ColorWheelPalette implements Palette {
  static final float BLACK_PROBABILITY = 0.4f;
  float[] hueOffsets;
  float blackProbability;
  float whiteProbability;
  float saturatedProbability;
  float hueValue;
   
  ColorWheelPalette(float[] hueOffsets) {
    this.hueOffsets = hueOffsets;
  }
   
  public int nextColor() {
    float h = (hueValue + hueOffsets[(int)random(hueOffsets.length)]) % TWO_PI;
    float s;
    float b;
    float r = random(1);
    if (r <  blackProbability) {
      s = 0;
      b = 0;
    } else if (r <  blackProbability+whiteProbability) {
      s = 0;
      b = 1;
    } else if (r <  blackProbability+whiteProbability+saturatedProbability) {
      s = 1;
      b = 1;
    } else {
      if (random(1) <  0.5f) {
        s = random(1);
        b = 1;
      } else {
        s = 1;
        b = random(1);
      }
    }
    return color(h, s, b);
  }
   
  public void reset() {   
    hueValue = random(TWO_PI);
    blackProbability = 0;
    whiteProbability = 0;
    saturatedProbability = 0;
    float r = random(1);
    if (random(1) <  0.3f) {
      // Only saturated
      saturatedProbability = 1;
    } else if (random(1) <  0.4f) {
      // saturated + black
      blackProbability = 1.0f/(1+hueOffsets.length);
      saturatedProbability = 1 - blackProbability;
    } else if (random(1) <  0.5f) {
      // saturated + white
      whiteProbability = 1.0f/(1+hueOffsets.length);
      saturatedProbability = 1 - whiteProbability;
    } else if (random(1) <  0.6f) {
      // saturated + black + white
      blackProbability = 1.0f/(2+hueOffsets.length);
      whiteProbability = 1.0f/(2+hueOffsets.length);
      saturatedProbability = 1 - blackProbability - whiteProbability;
    } else {
      // Unsaturated
    }
  }
}
 
//=============================================================================================================
Palette allPalettes[] = {
  new RandomPalette(),
  new RandomBrightPalette(), new RandomBrightPalette(), new RandomBrightPalette(), // Extra probability for random bright palette
  // Following palettes are based on color scheme described by ColorJack (http://www.colorjack.com/articles/color_formulas.html)
  new ColorWheelPalette(new float[]{0}), // Monochrome
  new ColorWheelPalette(new float[]{0, PI}), // Complementaty
  new ColorWheelPalette(new float[]{0, TWO_PI/12*5, TWO_PI/12*7}), // Split-Complementary
  new ColorWheelPalette(new float[]{0, TWO_PI/3, TWO_PI/3*2}), // Triadic
  new ColorWheelPalette(new float[]{0, TWO_PI/4, TWO_PI/4*2, TWO_PI/4*3}), // Tetradic
  new ColorWheelPalette(new float[]{0, TWO_PI/6, TWO_PI/6*3, TWO_PI/6*4}), // Four-tone
  new ColorWheelPalette(new float[]{0, TWO_PI/72*23, TWO_PI/72*31, TWO_PI/72*41, TWO_PI/72*49}), // Five-tone
  new ColorWheelPalette(new float[]{0, TWO_PI/12, TWO_PI/12*4, TWO_PI/12*5, TWO_PI/12*8, TWO_PI/12*9}), // Six-tone
  new ColorWheelPalette(new float[]{0, TWO_PI/24, TWO_PI/24*2, TWO_PI/24*3, TWO_PI/24*4, TWO_PI/24*5}) // Neutral
};
 
public Palette getRandomPalette() {
  Palette palette = allPalettes[(int)random(allPalettes.length)];
  palette.reset();
  return palette;
}

//=============================================================================================================
interface Shape {
  public boolean draw(PGraphics g); 
}
 
//=============================================================================================================
class Point implements Shape {
  static final float MAX_WEIGHT = 7;
  static final float DELTA_WEIGHT = 0.2f;
   
  float x;
  float y;
  int clr;
  float w;
   
  Point(PGraphics g, Palette p) {
     x = random(0, g.width);
     y = random(0, g.height);
     clr = p.nextColor();
     w = 0;
  }
   
  public boolean draw(PGraphics g) {
    w += DELTA_WEIGHT;
    g.strokeWeight(w);
    g.stroke(clr);
    g.point(x, y);
    return w <  MAX_WEIGHT;
  } 
}
 
//=============================================================================================================
class Spiral implements Shape {
  static final float MIN_RADIUS = 0.3f;
  static final float MAX_RADIUS = 0.6f;
  static final int WEIGHT = 5;
  static final int STEPS = 10;
  static final float R_STEP = 0.003f;
  static final float A_STEP = 0.05f;
   
  float radius;
  float x;
  float y;
  int clr;
  float r;
  float a;
  float aDelta;
   
  Spiral(PGraphics g, Palette p) {
     radius = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     x = random(g.width*MIN_RADIUS, g.width*(1-MIN_RADIUS));
     y = random(g.height*MIN_RADIUS, g.height*(1-MIN_RADIUS));
     clr = p.nextColor();
     r = 0;
     a = random(TWO_PI);
     aDelta = random(-A_STEP, A_STEP);
  }
   
  public boolean draw(PGraphics g) {
    g.strokeWeight(WEIGHT);
    g.stroke(clr);
    for (int i=0; i<STEPS; i++) {
      float x0 = x + r*radius*sin(a);
      float y0 = y + r*radius*cos(a);
      r += R_STEP;
      a += aDelta;
      float x1 = x + r*radius*sin(a);
      float y1 = y + r*radius*cos(a);
      g.line(x0, y0, x1, y1);
      if (r >= 1) {
        return false;
      }
    }
    return true;
  } 
}
 
//=============================================================================================================
class Circle implements Shape {
  static final float MIN_RADIUS = 0.1f;
  static final float MAX_RADIUS = 0.4f;
  static final float R_STEP = 0.05f;
   
  float radius;
  float x;
  float y;
  int clr;
  float r;
   
  Circle(PGraphics g, Palette p) {
     radius = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     x = random(g.width*MIN_RADIUS, g.width*(1-MIN_RADIUS));
     y = random(g.height*MIN_RADIUS, g.height*(1-MIN_RADIUS));
     clr = p.nextColor();
     r = 0;
  }
   
  public boolean draw(PGraphics g) {
    r += R_STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.ellipseMode(RADIUS);
    g.ellipse(x, y, radius*r, radius*r);
    return r <  1;
  } 
   
}
 
//=============================================================================================================
class Blot implements Shape {
  static final int MIN_SIDES = 6;
  static final int MAX_SIDES = 40;
  static final float MIN_RADIUS = 0.1f;
  static final float MAX_RADIUS = 0.4f;
  static final float R_STEP = 0.05f;
   
  int sides;
  float radiuses[];
  float x;
  float y;
  int clr;
  float r;
   
  Blot(PGraphics g, Palette p) {
     sides = (int)random(MIN_SIDES, MAX_SIDES);
     radiuses = new float[sides];
     for(int i=0; i<sides; i++) {
       radiuses[i] = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     }
     x = random(g.width*MIN_RADIUS, g.width*(1-MIN_RADIUS));
     y = random(g.height*MIN_RADIUS, g.height*(1-MIN_RADIUS));
     clr = p.nextColor();
     r = 0;
  }
   
  public boolean draw(PGraphics g) {
    r += R_STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.beginShape();
    for(int i=0; i<sides+3; i++) {
      g.curveVertex(x+r*radiuses[i%sides]*sin(TWO_PI/sides*i), y+r*radiuses[i%sides]*cos(TWO_PI/sides*i));
    }    
    g.endShape();
    return r <  1;
  } 
}

class Ellipse implements Shape {
  static final float MIN_RADIUS = 0.1f;
  static final float MAX_RADIUS = 0.4f;
  static final float R_STEP = 0.05f;
   
  float radius1,radius2;
  float x;
  float y;
  int clr;
  float r;
   
  Ellipse(PGraphics g, Palette p) {
     radius1 = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     radius2 = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     x = random(g.width*MIN_RADIUS, g.width*(1-MIN_RADIUS));
     y = random(g.height*MIN_RADIUS, g.height*(1-MIN_RADIUS));
     clr = p.nextColor();
     r = 0;
  }
   
  public boolean draw(PGraphics g) {
    r += R_STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.ellipseMode(RADIUS);
    g.ellipse(x, y, radius1*r, radius2*r);
    return r <  1;
  } 
   
}

class Rect implements Shape {
  static final float MIN_LEN = 0.1f;
  static final float MAX_LEN = 0.4f;
  static final float STEP = 0.04f;
   
  float w,h;
  float x;
  float y;
  int clr;
  float  wlen, hlen;
  
  Rect(PGraphics g, Palette p) {
   w = random(g.width*MIN_LEN, g.width*MAX_LEN); 
   h = random(g.width*MIN_LEN, g.width*MAX_LEN); 
   x = random(g.width*MIN_LEN, g.width*(1-MIN_LEN));
   y = random(g.height*MIN_LEN, g.height*(1-MIN_LEN));
   clr = p.nextColor();
   wlen = 0;
   hlen = 0;
  }
   
  public boolean draw(PGraphics g) {
    wlen += STEP;
    hlen +=STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.rectMode(CORNER);
    g.rect(x, y, w, h);
    return wlen <  1 && hlen <  1;
  } 
   
}

class Line implements Shape {
  static final float MIN_LEN = 0.1f;
  static final float MAX_LEN = 0.9f;
  static final float STEP = 0.05f;
   
  float x2;
  float y2;
  float x;
  float y;
  int clr;
  float  step;
  
  Line(PGraphics g, Palette p) {
   x2 = random(g.width*MIN_LEN, g.width*MAX_LEN); 
   y2 = random(g.height*MIN_LEN, g.height*(1-MIN_LEN)); 
   x = random(g.width*MIN_LEN, g.width*(1-MIN_LEN));
   y = random(g.height*MIN_LEN, g.height*(1-MIN_LEN));
   clr = p.nextColor();
   step = 0;
  }
   
  public boolean draw(PGraphics g) {
    step += STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.line(x, y, (1-step)*x+step*x2, (1-step)*y+step*y2);
    return step <  1;
  } 
   
}

class SimpleLine implements Shape {
  static final float MIN_LEN = 0.1f;
  static final float MAX_LEN = 1.0f;
  static final float STEP = 0.05f;
   
  float x2;
  float y2;
  float x;
  float y;
  int clr;
  float  step;
  
  SimpleLine(PGraphics g, Palette p) {
   x = random(g.width*MIN_LEN, g.width*(1-MIN_LEN));
   y = random(g.height*MIN_LEN, g.height*(1-MIN_LEN));
   clr = p.nextColor();
   step = 0;
  }
   
  public boolean draw(PGraphics g) {
    step += STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.line(0,0, step*x, step*y);
    return step <  1;
  } 
   
}
 
//=============================================================================================================
class ShapeGenerator {
  float pointProbability;
  float spiralProbability;
  float circleProbability;
  float blotProbability;
  float rectProbability;
  float lineProbability;
  float simpleLineProbability;
  float ellipseProbability;
   
ShapeGenerator(float pointProbability, float spiralProbability,
                 float circleProbability, float blotProbability,   float rectProbability, float lineProbability, float simpleLineProbability, float ellipseProbability) {
      this.pointProbability = pointProbability;
    this.spiralProbability = spiralProbability;
    this.circleProbability = circleProbability;
    this.blotProbability = blotProbability;
    this.rectProbability = rectProbability;
    this.lineProbability = lineProbability;
    this.simpleLineProbability = simpleLineProbability;
    this.ellipseProbability = ellipseProbability;
  }
   
  public void createShapes(ArrayList shapes, PGraphics g, Palette p) {
      if (random(1) <  pointProbability) {
      shapes.add(new Point(g, p));
    }
    if (random(1) <  spiralProbability) {
      shapes.add(new Spiral(g, p));
    }
    if (random(1) <  circleProbability) {
      shapes.add(new Circle(g, p));
    }
   if (random(1) <  blotProbability) {
     shapes.add(new Blot(g, p));
   }
   if (random(1) <  rectProbability) {
    shapes.add(new Rect(g,p));
   }
   if (random(1) <  lineProbability) {
    shapes.add(new Line(g,p));
   }
   if (random(1) <  simpleLineProbability) {
    shapes.add(new SimpleLine(g,p));
   }
   if (random(1) <  ellipseProbability) {
    shapes.add(new Ellipse(g,p));
   }
  }

}
 
//=============================================================================================================
ShapeGenerator allShapeGenerators[] = {
  new ShapeGenerator(0,0,0,0,0.13f,0.1f,0,0),
  new ShapeGenerator(0,0,0,0,0.03f,0,0.12f,0.12f),
  new ShapeGenerator(0,0,0,0,0.03f,0.2f,0.1f,0.02f),
  //  new ShapeGenerator(0, 0.07, 0, 0,0,0,0,0), // Spirals only
 // new ShapeGenerator(0, 0.04, 0, 0,0,0,0,0), // Spirals only (less frequent)
  new ShapeGenerator(0.5f, 0.03f, 0, 0,0,0,0,0), // Points ant spirals
  //new ShapeGenerator(0, 0, 0, 0.07,0,0,0,0), // Blots only
  //new ShapeGenerator(0, 0, 0, 0.04,0,0,0,0), // Blots only (less frequent)
 // new ShapeGenerator(0, 0, 0.03, 0.04,0,0,0,0), // Circles and blots
 // new ShapeGenerator(0, 0.02, 0.02, 0.03,0,0,0,0), // Spirals, circles and blots
 // new ShapeGenerator(0, 0.02, 0.01, 0.02,0,0,0,0), // Spirals, circles and blots (less frequent)
  new ShapeGenerator(0.3f, 0.02f, 0.01f, 0.02f,0,0,0,0), // Points, spirals, circles and blots
};
 
 
public ShapeGenerator getRandomShapeGenerator() {
  return allShapeGenerators[(int)random(allShapeGenerators.length)];
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "SoundKaleidoscope" });
  }
}

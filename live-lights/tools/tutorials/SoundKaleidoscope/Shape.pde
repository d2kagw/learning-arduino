//=============================================================================================================
interface Shape {
  boolean draw(PGraphics g); 
}
 
//=============================================================================================================
class Point implements Shape {
  static final float MAX_WEIGHT = 7;
  static final float DELTA_WEIGHT = 0.2;
   
  float x;
  float y;
  color clr;
  float w;
   
  Point(PGraphics g, Palette p) {
     x = random(0, g.width);
     y = random(0, g.height);
     clr = p.nextColor();
     w = 0;
  }
   
  boolean draw(PGraphics g) {
    w += DELTA_WEIGHT;
    g.strokeWeight(w);
    g.stroke(clr);
    g.point(x, y);
    return w < MAX_WEIGHT;
  } 
}
 
//=============================================================================================================
class Spiral implements Shape {
  static final float MIN_RADIUS = 0.3;
  static final float MAX_RADIUS = 0.6;
  static final int WEIGHT = 5;
  static final int STEPS = 10;
  static final float R_STEP = 0.003;
  static final float A_STEP = 0.05;
   
  float radius;
  float x;
  float y;
  color clr;
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
   
  boolean draw(PGraphics g) {
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
  static final float MIN_RADIUS = 0.1;
  static final float MAX_RADIUS = 0.4;
  static final float R_STEP = 0.05;
   
  float radius;
  float x;
  float y;
  color clr;
  float r;
   
  Circle(PGraphics g, Palette p) {
     radius = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     x = random(g.width*MIN_RADIUS, g.width*(1-MIN_RADIUS));
     y = random(g.height*MIN_RADIUS, g.height*(1-MIN_RADIUS));
     clr = p.nextColor();
     r = 0;
  }
   
  boolean draw(PGraphics g) {
    r += R_STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.ellipseMode(RADIUS);
    g.ellipse(x, y, radius*r, radius*r);
    return r < 1;
  } 
   
}
 
//=============================================================================================================
class Blot implements Shape {
  static final int MIN_SIDES = 6;
  static final int MAX_SIDES = 40;
  static final float MIN_RADIUS = 0.1;
  static final float MAX_RADIUS = 0.4;
  static final float R_STEP = 0.05;
   
  int sides;
  float radiuses[];
  float x;
  float y;
  color clr;
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
   
  boolean draw(PGraphics g) {
    r += R_STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.beginShape();
    for(int i=0; i<sides+3; i++) {
      g.curveVertex(x+r*radiuses[i%sides]*sin(TWO_PI/sides*i), y+r*radiuses[i%sides]*cos(TWO_PI/sides*i));
    }    
    g.endShape();
    return r < 1;
  } 
}

class Ellipse implements Shape {
  static final float MIN_RADIUS = 0.1;
  static final float MAX_RADIUS = 0.4;
  static final float R_STEP = 0.05;
   
  float radius1,radius2;
  float x;
  float y;
  color clr;
  float r;
   
  Ellipse(PGraphics g, Palette p) {
     radius1 = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     radius2 = random(g.width*MIN_RADIUS, g.width*MAX_RADIUS);
     x = random(g.width*MIN_RADIUS, g.width*(1-MIN_RADIUS));
     y = random(g.height*MIN_RADIUS, g.height*(1-MIN_RADIUS));
     clr = p.nextColor();
     r = 0;
  }
   
  boolean draw(PGraphics g) {
    r += R_STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.ellipseMode(RADIUS);
    g.ellipse(x, y, radius1*r, radius2*r);
    return r < 1;
  } 
   
}

class Rect implements Shape {
  static final float MIN_LEN = 0.1;
  static final float MAX_LEN = 0.4;
  static final float STEP = 0.04;
   
  float w,h;
  float x;
  float y;
  color clr;
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
   
  boolean draw(PGraphics g) {
    wlen += STEP;
    hlen +=STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.rectMode(CORNER);
    g.rect(x, y, w, h);
    return wlen < 1 && hlen < 1;
  } 
   
}

class Line implements Shape {
  static final float MIN_LEN = 0.1;
  static final float MAX_LEN = 0.9;
  static final float STEP = 0.05;
   
  float x2;
  float y2;
  float x;
  float y;
  color clr;
  float  step;
  
  Line(PGraphics g, Palette p) {
   x2 = random(g.width*MIN_LEN, g.width*MAX_LEN); 
   y2 = random(g.height*MIN_LEN, g.height*(1-MIN_LEN)); 
   x = random(g.width*MIN_LEN, g.width*(1-MIN_LEN));
   y = random(g.height*MIN_LEN, g.height*(1-MIN_LEN));
   clr = p.nextColor();
   step = 0;
  }
   
  boolean draw(PGraphics g) {
    step += STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.line(x, y, (1-step)*x+step*x2, (1-step)*y+step*y2);
    return step < 1;
  } 
   
}

class SimpleLine implements Shape {
  static final float MIN_LEN = 0.1;
  static final float MAX_LEN = 1.0;
  static final float STEP = 0.05;
   
  float x2;
  float y2;
  float x;
  float y;
  color clr;
  float  step;
  
  SimpleLine(PGraphics g, Palette p) {
   x = random(g.width*MIN_LEN, g.width*(1-MIN_LEN));
   y = random(g.height*MIN_LEN, g.height*(1-MIN_LEN));
   clr = p.nextColor();
   step = 0;
  }
   
  boolean draw(PGraphics g) {
    step += STEP;
    g.stroke(clr);
    g.noFill();
    g.strokeWeight(1);
    g.line(0,0, step*x, step*y);
    return step < 1;
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
   
  void createShapes(ArrayList shapes, PGraphics g, Palette p) {
      if (random(1) < pointProbability) {
      shapes.add(new Point(g, p));
    }
    if (random(1) < spiralProbability) {
      shapes.add(new Spiral(g, p));
    }
    if (random(1) < circleProbability) {
      shapes.add(new Circle(g, p));
    }
   if (random(1) < blotProbability) {
     shapes.add(new Blot(g, p));
   }
   if (random(1) < rectProbability) {
    shapes.add(new Rect(g,p));
   }
   if (random(1) < lineProbability) {
    shapes.add(new Line(g,p));
   }
   if (random(1) < simpleLineProbability) {
    shapes.add(new SimpleLine(g,p));
   }
   if (random(1) < ellipseProbability) {
    shapes.add(new Ellipse(g,p));
   }
  }

}
 
//=============================================================================================================
ShapeGenerator allShapeGenerators[] = {
  new ShapeGenerator(0,0,0,0,0.13,0.1,0,0),
  new ShapeGenerator(0,0,0,0,0.03,0,0.12,0.12),
  new ShapeGenerator(0,0,0,0,0.03,0.2,0.1,0.02),
  //  new ShapeGenerator(0, 0.07, 0, 0,0,0,0,0), // Spirals only
 // new ShapeGenerator(0, 0.04, 0, 0,0,0,0,0), // Spirals only (less frequent)
  new ShapeGenerator(0.5, 0.03, 0, 0,0,0,0,0), // Points ant spirals
  //new ShapeGenerator(0, 0, 0, 0.07,0,0,0,0), // Blots only
  //new ShapeGenerator(0, 0, 0, 0.04,0,0,0,0), // Blots only (less frequent)
 // new ShapeGenerator(0, 0, 0.03, 0.04,0,0,0,0), // Circles and blots
 // new ShapeGenerator(0, 0.02, 0.02, 0.03,0,0,0,0), // Spirals, circles and blots
 // new ShapeGenerator(0, 0.02, 0.01, 0.02,0,0,0,0), // Spirals, circles and blots (less frequent)
  new ShapeGenerator(0.3, 0.02, 0.01, 0.02,0,0,0,0), // Points, spirals, circles and blots
};
 
 
ShapeGenerator getRandomShapeGenerator() {
  return allShapeGenerators[(int)random(allShapeGenerators.length)];
}


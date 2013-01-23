class DiscoRenderer extends Renderer  {
  int hue;
  int hueMax;
  
  DiscoRenderer(PApplet core) {
    hue = 0;
    hueMax = 100;
  }
  
  // TODO: need to supply hue adjustments
  boolean draw() {
    // set the color mode for simple rendering of hue
    colorMode(HSB, hueMax, hueMax, hueMax);
    
    // set stroke
    noStroke();
    
    // draw four blocks
    fill(int(random(1,100)), hueMax, hueMax);
    rect(0, 0, width/2, height/2);
    
    fill(int(random(1,100)), hueMax, hueMax);
    rect(width/2, 0, width/2, height/2);
    
    fill(int(random(1,100)), hueMax, hueMax);
    rect(0, height/2, width/2, height/2);
    
    fill(int(random(1,100)), hueMax, hueMax);
    rect(width/2, height/2, width/2, height/2);
    
    // just return true for now
    // TODO: implemenent error handling
    return true;
  }
  
  void wake_up() {
    println("Disco Renderer: Waking Up");
    frameRate(2);
  }
  
  void sleep() {
    println("Disco Renderer: Sleeping");
  }
}


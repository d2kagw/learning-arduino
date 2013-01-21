class DiscoRenderer extends Renderer  {
  int hue;
  int hueMax;
  
  DiscoRenderer(PApplet core) {
    hue = 0;
    hueMax = 100;
    colorMode(HSB, hueMax, hueMax, hueMax);
  }
  
  // TODO: need to supply hue adjustments
  boolean draw() {
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
    frameRate(4);
  }
  
  void sleep() {
    println("Disco Renderer: Sleeping");
  }
}


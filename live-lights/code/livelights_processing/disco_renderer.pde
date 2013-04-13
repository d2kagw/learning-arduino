class DiscoRenderer extends Renderer  {
  int hueMax;
  int render_x, render_y, render_width, render_height;
  
  int currentMode;
  static final int modeCount = 5;
  
  int timer;
  int timerChange;
  
  DiscoRenderer(PApplet core, int t_render_x, int t_render_y, int t_render_width, int t_render_height) {
    render_x      = t_render_x;
    render_y      = t_render_y;
    render_width  = t_render_width;
    render_height = t_render_height;
    
    hueMax = 100;
  }
  
  // TODO: need to make use of the 
  boolean draw(int modifier) {
    // set the color mode for simple rendering of hue
    colorMode(HSB, hueMax, hueMax, hueMax);
    
    // set stroke
    noStroke();
    
    switch(currentMode){
      case 0:
        drawColorCorners(modifier);
        break;
      case 1:
        drawColorHueChange(modifier);
        break;     
      case 2:
        drawColorHueChangeFast(modifier);
        break;
      case 3:
        drawStrobe(modifier);
        break;
      case 4:
        drawColorStrobe(modifier);
        break;
       default:
         println("No idea what " + currentMode + " mode is");
    };
    
    timer += 1;
    if (timer > timerChange) {
      timeForChange();
    }
    
    return true;
  }
  
  void wake_up() {
    println("Disco Renderer: Waking Up");
    frameRate(12);
    
    timeForChange();
  }
  
  void sleep() {
    println("Disco Renderer: Sleeping");
  }
  
  // ------------------------------------
  
  void timeForChange() {
    timerChange = floor(random(frameRate/2, frameRate*4));
    timer = 0;
    
    currentMode = floor(random(0, modeCount));
    drawColorHueChange_process = int(random(1, hueMax));
  }
  
  // ------------------------------------
  
  void drawColorCorners(int modifier) {
    // draw four blocks
    fill(int(random(1,100)), hueMax, hueMax);
    rect(render_x, render_y, render_width/2, render_height/2);
    
    fill(int(random(1,100)), hueMax, hueMax);
    rect((render_width/2)+render_x, render_y, render_width/2, render_height/2);
    
    fill(int(random(1,100)), hueMax, hueMax);
    rect(render_x, (render_height/2)+render_y, render_width/2, render_height/2);
    
    fill(int(random(1,100)), hueMax, hueMax);
    rect((render_width/2)+render_x, (render_height/2)+render_y, render_width/2, render_height/2);
  }
  
  // ------------------------------------
  
  int drawColorHueChange_process = 0;
  void drawColorHueChange(int modifier) {
    // Hue adjust
    drawColorHueChange_process -= 1;
    if (drawColorHueChange_process > hueMax) drawColorHueChange_process = 0;
    if (drawColorHueChange_process <      0) drawColorHueChange_process = hueMax;
    
    // draw four blocks
    fill(drawColorHueChange_process, hueMax, hueMax);
    rect(render_x, render_y, render_width, render_height);
  }
  
  // ------------------------------------
  
  void drawColorHueChangeFast(int modifier) {
    // Hue adjust
    drawColorHueChange_process += 10;
    if (drawColorHueChange_process > hueMax) drawColorHueChange_process = 0;
    if (drawColorHueChange_process <      0) drawColorHueChange_process = hueMax;
    
    // draw four blocks
    fill(drawColorHueChange_process, hueMax, hueMax);
    rect(render_x, render_y, render_width, render_height);
  }
  
  // ------------------------------------
  
  boolean strobeState = false;
  void drawStrobe(int modifier) {
    // strobe state
    if (strobeState) {
      fill(0, 0, hueMax);
    } else {
      fill(0, 0, 0);
    }
    rect(render_x, render_y, render_width, render_height);
    strobeState = !strobeState;
  }
  
  // ------------------------------------
  
  void drawColorStrobe(int modifier) {
    // strobe state
    if (strobeState) {
      fill(floor(random(0, hueMax)), hueMax, hueMax);
    } else {
      fill(0, hueMax, 0);
    }
    rect(render_x, render_y, render_width, render_height);
    strobeState = !strobeState;
  }
}


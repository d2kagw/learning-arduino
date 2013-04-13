class ColorRenderer extends Renderer  {
  int hue;
  int hueMax;
  int render_x, render_y, render_width, render_height;
  
  ColorRenderer(PApplet core, int t_render_x, int t_render_y, int t_render_width, int t_render_height) {
    render_x      = t_render_x;
    render_y      = t_render_y;
    render_width  = t_render_width;
    render_height = t_render_height;
    
    hue = 0;
    hueMax = 100;
  }
  
  // TODO: need to supply hue adjustments
  boolean draw(int modifier) {
    // set the color mode for simple rendering of hue
    colorMode(HSB, hueMax, hueMax, hueMax);
    
    // draw the box
    fill(modifier, hueMax, hueMax);
    rect(render_x, render_y, render_width, render_height);
    
    // just return true for now
    // TODO: implemenent error handling
    return true;
  }
  
  void wake_up() {
    println("Color Renderer: Waking Up");
    frameRate(12);
  }
  
  void sleep() {
    println("Color Renderer: Sleeping");
  }
}


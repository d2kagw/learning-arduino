import processing.video.*;
class MovieRenderer extends Renderer  {
  Movie movie;
  PApplet the_core;
  int render_x, render_y, render_width, render_height;
  
  MovieRenderer(PApplet core, int t_render_x, int t_render_y, int t_render_width, int t_render_height) {
    render_x      = t_render_x;
    render_y      = t_render_y;
    render_width  = t_render_width;
    render_height = t_render_height;
    the_core = core;
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
  
  boolean shouldManageBrightness() {
    return true;
  }
  
  void wake_up() {
    println("Movie Renderer: Waking Up");
    frameRate(30);
    
    fill(0);
    rect(render_x, render_y, render_width, render_height);
    
    movie = new Movie(the_core, "sample.avi");
    movie.loop();
  }
  
  void sleep() {
    println("Movie Renderer: Sleeping");
    movie.stop();
  }
  
  boolean draw(int modifier) {
    image(movie, render_x, render_y, render_width, render_height);
    
    // just return true for now
    // TODO: implemenent error handling
    return true;
  }
}

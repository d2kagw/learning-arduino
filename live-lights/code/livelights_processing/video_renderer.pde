import processing.video.*;
class VideoRenderer extends Renderer  {
  Capture video;
  int render_x, render_y, render_width, render_height;
  
  VideoRenderer(PApplet core, int t_render_x, int t_render_y, int t_render_width, int t_render_height) {
    render_x      = t_render_x;
    render_y      = t_render_y;
    render_width  = t_render_width;
    render_height = t_render_height;
    
    String[] cameras = Capture.list();
    
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
      
      // TODO: we need to feed in the camera name here
      video = new Capture(core, render_width, render_height, 30);
    }
  }
  
  boolean shouldManageBrightness() {
    return true;
  }
  
  void wake_up() {
    println("Camera Renderer: Waking Up");
    
    fill(0);
    rect(render_x, render_y, render_width, render_height);
    
    frameRate(18);
    video.start();
  }
  
  void sleep() {
    println("Camera Renderer: Sleeping");
    video.stop();
  }
  
  boolean draw(int modifier) {
    // Read image from the camera
    if (video.available()) {
      video.read();
    }
    video.loadPixels();
    
    // lets render actual picture in the background for testing
    image(video, render_x, render_y, render_width, render_height);
    
    // just return true for now
    // TODO: implemenent error handling
    return true;
  }
}

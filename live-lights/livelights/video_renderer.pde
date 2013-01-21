import processing.video.*;
class VideoRenderer extends Renderer  {
  Capture video;
  
  VideoRenderer(PApplet core) {
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
      video = new Capture(core, width, height, "Display iSight");
    }
  }
  
  void wake_up() {
    println("Camera Renderer: Waking Up");
    video.start();
  }
  
  void sleep() {
    println("Camera Renderer: Sleeping");
    video.stop();
  }
  
  boolean draw() {
    // Read image from the camera
    if (video.available()) {
      video.read();
    }
    video.loadPixels();
    
    // lets render actual picture in the background for testing
    image(video, 0, 0, width, height);
    
    // just return true for now
    // TODO: implemenent error handling
    return true;
  }
}

// Renderer Super Class
class Renderer {
  Renderer() {
    // nada
  }
  boolean draw() {
    return true;
  }
  void wake_up() {
    println("Wake Up");
  }
  void sleep() {
    println("Sleep");
  }
}

// ------------------------------

class ColorRenderer extends Renderer  {
  int hue;
  int hueMax;
  ColorRenderer(PApplet core) {
    hue = 0;
    hueMax = 100;
    
    colorMode(HSB, hueMax, hueMax, hueMax);
  }
  
  boolean draw() {
    hue += 1;
    if (hue > hueMax) hue = 0;
    
    fill(hue, hueMax, hueMax);
    rect(0, 0, width, height);
    
    return true;
  }
}

// ------------------------------
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
      
      // TODO: we need to feed in the frame rate here
      video = new Capture(core, width, height, 30);
    }
  }
  
  void wake_up() {
    println("Camera Renderer: Waking Up");
    video.start();
  }
  
  boolean draw() {
    // Read image from the camera
    if (video.available()) {
      video.read();
    }
    video.loadPixels();
    
    // lets render actual picture in the background for testing
    image(video, 0, 0, width, height);
    
    return true;
  }
}

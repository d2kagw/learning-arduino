import processing.video.*;

// Number of columns and rows in our system
int columns = 15;
int rows = 10;

int videoScaleWidth, videoScaleHeight;

// Variable to hold onto Capture object
Capture video;

void setup() {
  size(320,240);
  
  videoScaleWidth  = width  / columns;
  videoScaleHeight = height / rows;
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    video = new Capture(this, columns, rows, 30);
    video.start();     
  }
  
}

void draw() {
  // Read image from the camera
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  
  // lets render actual picture in the background for testing
  image(video, 0, 0, 320, 240);
  
  // render the pixels
  for (int column = 0; column < columns; column++) {
    for (int row = 0; row < rows; row++) {
      if (column == 0 || column == columns-1) {
        drawPixel(column, row);
      } else if (row == 0 || row == rows-1) {
        drawPixel(column, row);
      }
    }    
  }
}

void drawPixel(int column, int row) {
  // Where are we, pixel-wise?
  int x = column * videoScaleWidth;
  int y = row    * videoScaleHeight;
  
  // Looking up the appropriate color in the pixel array
  color c = video.pixels[column + row*video.width];
  
  fill(c);
  stroke(c);
  rect(x,y,videoScaleWidth,videoScaleHeight);
}


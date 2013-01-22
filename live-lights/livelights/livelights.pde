// Import Time
import processing.video.*;
import processing.serial.*;

// Display Settings
static final int   DISPLAY_WIDTH = 320;
static final float DISPLAY_RATIO = 16.0 / 9.0;

// LED Settings
static final int LED_COLUMNS = 10;//18;
static final int LED_ROWS    = 5;
int LED_BLOCK_WIDTH, LED_BLOCK_HEIGHT;

// Renderers & Render Modes
int render_mode = 0;
ArrayList renderers;
Renderer rendererColor, rendererDisco, rendererVideo;

// the serial port
Serial myPort;

void setup() {
  // set up the screen real estate
  println("Creating display: " + DISPLAY_WIDTH + "x" + ceil(DISPLAY_WIDTH/DISPLAY_RATIO));
  size(DISPLAY_WIDTH, ceil(DISPLAY_WIDTH/DISPLAY_RATIO));
  noSmooth();
  
  // ----------------------------------------------------
  // Setup the LED Structure
  
  LED_BLOCK_WIDTH  = ceil(DISPLAY_WIDTH / LED_COLUMNS);
  LED_BLOCK_HEIGHT = ceil(ceil(DISPLAY_WIDTH/DISPLAY_RATIO) / LED_ROWS);
  
  // ----------------------------------------------------
  // Setup the Renderers
  
  // Setup our renderers
  renderers = new ArrayList();
  println("Creating renderers, this can take a few seconds...");
  
  // create color renderer
  rendererColor = new ColorRenderer(this);
  renderers.add(rendererColor);
  
  // create disco renderer
  rendererDisco = new DiscoRenderer(this);
  renderers.add(rendererDisco);
  
  // create video renderer
  rendererVideo = new VideoRenderer(this);
  renderers.add(rendererVideo);
  
  // setup the renderer
  set_render_mode(0);
  
  // ---------------------------------------------------
  // Setup the serial comms
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 115200);
}

void draw() {
  // create/activate and render the current visualiser
  current_renderer().draw();
  
  // Load the pixels
  loadPixels();
  
  // render the pixels
  int current_pixel = 0;
  int led_count = ((LED_COLUMNS + LED_ROWS)*2);
  int brightness;
  byte[] pixel_colors = new byte[6 + (led_count*3)];
  
  pixel_colors[current_pixel++] = 'A';
  pixel_colors[current_pixel++] = 'd';
  pixel_colors[current_pixel++] = 'a';
  pixel_colors[current_pixel++] = byte((led_count - 1) >> 8);
  pixel_colors[current_pixel++] = byte((led_count - 1) & 0xff);
  pixel_colors[current_pixel++] = byte(pixel_colors[3] ^ pixel_colors[4] ^ 0x55);
  
  for (int column = 0; column < LED_COLUMNS; column++) {
    for (int row = 0; row < LED_ROWS; row++) {
      if (column == 0 || column == LED_COLUMNS-1 || row == 0 || row == LED_ROWS-1) {
        color the_color = drawPixel(column, row);
        pixel_colors[current_pixel++] = byte(red(the_color));
        pixel_colors[current_pixel++] = byte(green(the_color));
        pixel_colors[current_pixel++] = byte(blue(the_color));
      }
    }
  }
  
  pixel_colors[current_pixel++] = byte(0);
  pixel_colors[current_pixel++] = byte(0);
  pixel_colors[current_pixel++] = byte(0);    
  
  println(pixel_colors);
  myPort.write(pixel_colors);
}

// ----------------------------------------------------

color drawPixel(int column, int row) {
  stroke(0);
  
  // Where are we, pixel-wise?
  int x = column * LED_BLOCK_WIDTH;
  int y = row    * LED_BLOCK_HEIGHT;
  
  // Looking up the appropriate color in the pixel array
  int pixel = (y+(LED_BLOCK_HEIGHT/2)) * width + (x+(LED_BLOCK_WIDTH/2));
  color c = pixels[pixel];
  fill(c);
  
  // draw a block 
  rect(x, y, LED_BLOCK_WIDTH, LED_BLOCK_HEIGHT);
  rect(x+(LED_BLOCK_WIDTH/2), y+(LED_BLOCK_HEIGHT/2), 1, 1);
  
  // return the color
  return c;
}

// ----------------------------------------------------

// Set the Render mode
void set_render_mode(int mode_index) {
  // tell the renderer to stop processing anything it might be processing
  current_renderer().sleep();
  
  // set the renderer
  render_mode = mode_index;
  
  // get it running
  current_renderer().wake_up();
}

void next_render_mode() {
  int tmp = render_mode + 1;
  if (tmp > renderers.size()-1) {
    tmp = 0;
  }
  
  set_render_mode(tmp);
}

// Return the current Renderer
Renderer current_renderer() {
  return (Renderer)renderers.get(render_mode);
}

// ----------------------------------------------------

void keyPressed(){
  switch(key) {
    case('w'):
      println("Brightness up");
      break;
    case('s'):
      println("Brightness down");
      break;
      
    case('d'):
      println("Colour forward");
      break;
    case('a'):
      println("Colour back");
      break;
    
    case(' '):
      println("Cycle render mode");
      next_render_mode();
      break;
      
    default:
      println("Not sure what '" + key + "' is meant to do?");
  }
}

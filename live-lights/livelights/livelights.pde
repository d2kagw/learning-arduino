// Import Modules
import processing.serial.*;

// how much logging?
static final boolean VERBOSE = false;
static final boolean ENABLE_SERIAL_COMMS = true;

// Display Settings
static final float DISPLAY_RATIO  = 16.0 / 9.0;
static final int   DISPLAY_WIDTH  = 320;
static final int   DISPLAY_HEIGHT = ceil( DISPLAY_WIDTH / DISPLAY_RATIO );

// LED Settings
static final int LED_COLUMNS      = 18;
static final int LED_ROWS         = 10;
static final int LED_BLOCK_WIDTH  = ceil( DISPLAY_WIDTH / (LED_COLUMNS*1.0) );
static final int LED_BLOCK_HEIGHT = ceil( ceil( DISPLAY_WIDTH / DISPLAY_RATIO ) / LED_ROWS);
// Note, we deduct 4 because the corner LED's are doubled up using this equation
static final int LED_COUNT   = ((LED_COLUMNS + LED_ROWS) * 2) - 4;

// Colours & Processing
short[][] pixel_colors = new short[LED_COUNT][3],
     prev_pixel_colors = new short[LED_COUNT][3];
int[][] pixel_location = new int[LED_COLUMNS][LED_ROWS];
byte[][] gamma = new byte[256][3];

// Renderers & Render Modes
int render_mode = 0;
ArrayList renderers;
Renderer rendererColor, rendererDisco, rendererVideo;

// Serial Communications
Serial serialConnection;


// --------------------------------------------------------
// Setup the script
void setup() {
  // set up the screen real estate
  println("Creating display: " + DISPLAY_WIDTH + "x" + DISPLAY_HEIGHT);
  size(DISPLAY_WIDTH, DISPLAY_HEIGHT);
  noSmooth();
  
  // ----------------------------------------------------
  // Pre-Process values & attributes
  float f;
  int i;
  for(i=0; i<256; i++) {
    f           = pow((float)i / 255.0, 2.8);
    gamma[i][0] = (byte)(f * 255.0);
    gamma[i][1] = (byte)(f * 240.0);
    gamma[i][2] = (byte)(f * 220.0);
  };
  
  
  // ----------------------------------------------------
  // Setup the Renderers
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
  if (ENABLE_SERIAL_COMMS) {
    println("Here's our serial ports:");
    println(Serial.list());
    serialConnection = new Serial(this, Serial.list()[6], 115200);
  }
}


// --------------------------------------------------------
// Run the Renderers & Generate output
void draw() {
  // create/activate and render the current visualiser
  current_renderer().draw();
  
  // Load the pixels
  loadPixels();
  
  // make sure the color mode is correct
  colorMode(RGB, 100);
  
  // create the LED array
  int pixel_colors_counter = 0;
  byte[] pixel_colors = new byte[6 + (LED_COUNT*3)];
  pixel_colors[pixel_colors_counter++] = 'A';
  pixel_colors[pixel_colors_counter++] = 'd';
  pixel_colors[pixel_colors_counter++] = 'a';
  pixel_colors[pixel_colors_counter++] = byte((LED_COUNT - 1) >> 8);
  pixel_colors[pixel_colors_counter++] = byte((LED_COUNT - 1) & 0xff);
  pixel_colors[pixel_colors_counter++] = byte(pixel_colors[3] ^ pixel_colors[4] ^ 0x55);
  
  // We know how many pixels there are, so lets walk around the display
  // the first LED will be the North West pixel (top left corner of the screen)
  int row_id, column_id;
  for (int pixel_id = 0; pixel_id < LED_COUNT; pixel_id ++) {
    // get the position for the LED
    int[] pixel_colrow = positionForLED(pixel_id);
    
    // get the colour for the LED
    color pixel_color  = colorForLED(pixel_colrow[0], pixel_colrow[1]);
    representLED(pixel_colrow[0], pixel_colrow[1], pixel_color);
    
    // write the data to the array
    pixel_colors[pixel_colors_counter++] = byte(red(pixel_color));
    pixel_colors[pixel_colors_counter++] = byte(green(pixel_color));
    pixel_colors[pixel_colors_counter++] = byte(blue(pixel_color));
  }
  
  // Annndddd... Output!!!
  if (VERBOSE) println(pixel_colors);
  if (ENABLE_SERIAL_COMMS) serialConnection.write(pixel_colors);
}


// ----------------------------------------------------
// find the column & row index for a particular LED
int[] positionForLED(int led_index) {
  int col_max = LED_COLUMNS-1;
  int row_max = LED_ROWS-1;
  int tCol, tRow, tLed_index;
  
  if (led_index > LED_COUNT-1) {
    println(LED_COUNT + " DOESN'T EXIST!!! (the index starts at zero)");
    int[] error_response = {-1, -1};
    return error_response;
  } else {
    if (led_index < LED_COUNT/2) {
      tCol = min(col_max, led_index);
      tRow = led_index - col_max;
      if (led_index < col_max) {
        tRow = 0;
      }
    } else {
      tLed_index = LED_COUNT - led_index;
      tCol = tLed_index - row_max;
      tRow = min(row_max, tLed_index);
      if (tCol < 0) {
        tCol = 0;
      }
    }
    int[] response = {tCol, tRow};
    return response;
  }
}

// Color selection/generation
color colorForLED(int column, int row) {
  // Where are we, pixel-wise?
  int x = column * LED_BLOCK_WIDTH;
  int y = row    * LED_BLOCK_HEIGHT;
  
  // Looking up the appropriate color in the pixel array
  int pixel_north = (y+(LED_BLOCK_HEIGHT/2)-2) * width + (x+(LED_BLOCK_WIDTH/2)  );
  int pixel_east  = (y+(LED_BLOCK_HEIGHT/2)  ) * width + (x+(LED_BLOCK_WIDTH/2)+2);
  int pixel_south = (y+(LED_BLOCK_HEIGHT/2)+2) * width + (x+(LED_BLOCK_WIDTH/2)  );
  int pixel_west  = (y+(LED_BLOCK_HEIGHT/2)  ) * width + (x+(LED_BLOCK_WIDTH/2)-2);
  
  color pixel_color = color( int((  red(pixels[pixel_north]) +   red(pixels[pixel_east]) +   red(pixels[pixel_south]) +   red(pixels[pixel_west])) / 4),
                             int((green(pixels[pixel_north]) + green(pixels[pixel_east]) + green(pixels[pixel_south]) + green(pixels[pixel_west])) / 4),
                             int(( blue(pixels[pixel_north]) +  blue(pixels[pixel_east]) +  blue(pixels[pixel_south]) +  blue(pixels[pixel_west])) / 4));
  
  // return the color
  return pixel_color;
}

// draw a block where the pixel is
void representLED(int column, int row, color pixel_color) {
  int x = column * LED_BLOCK_WIDTH;
  int y = row    * LED_BLOCK_HEIGHT;
  stroke(0);
  fill(pixel_color);
  rect(x, y, LED_BLOCK_WIDTH, LED_BLOCK_HEIGHT);
  rect(x+(LED_BLOCK_WIDTH/2), y+(LED_BLOCK_HEIGHT/2), 1, 1);
}


// ----------------------------------------------------
// IR Remote Simulation
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


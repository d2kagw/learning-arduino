// Import Modules
import processing.serial.*;
Serial serialConnection;

// how much logging?
static final boolean VERBOSE = false;
static final boolean ENABLE_SERIAL_COMMS = false;

// Video Settings
static final float VIDEO_RATIO  = 16.0 / 9.0;
static final int   VIDEO_WIDTH  = 320;
static final int   VIDEO_HEIGHT = ceil( VIDEO_WIDTH / VIDEO_RATIO );

// Display Settings
static final int HISTOGRAM_WIDTH  = 255;
static final int HISTOGRAM_HEIGHT = VIDEO_HEIGHT / 4;
static final int DISPLAY_WIDTH    = VIDEO_WIDTH + HISTOGRAM_WIDTH;
static final int DISPLAY_HEIGHT   = VIDEO_HEIGHT;

// LED Settings
static final int LED_COLUMNS      = 18;
static final int LED_ROWS         = 10;
static final int LED_BLOCK_WIDTH  = ceil( VIDEO_WIDTH / (LED_COLUMNS*1.0) );
static final int LED_BLOCK_HEIGHT = ceil( ceil( VIDEO_WIDTH / VIDEO_RATIO ) / LED_ROWS);
// Note, we deduct 4 because the corner LED's are doubled up using this equation
static final int LED_COUNT   = ((LED_COLUMNS + LED_ROWS) * 2) - 4;

// Colours, Histograms & Processing
static final int MIN_BRIGHTNESS = 40;
static final int HISTOGRAM_AMBIENT_LEVEL = 100;
static final int HISTOGRAM_AMBIENT_RANGE = 40;
int[][] pixel_colors = new int[LED_COUNT][3];
int[][]    histogram = new int[3][256];
byte[][]       gamma = new byte[256][3];

// Renderers & Render Modes
int render_mode = 0;
ArrayList renderers;
Renderer rendererColor, rendererDisco, rendererVideo;

// Modifier Settings
int modifier_brightness = 100;
int modifier_renderer   = 0;

// Odds and ends
int channel_max;
int histogram_x, histogram_y; 

// --------------------------------------------------------
// Setup the script
void setup() {
  // set up the screen real estate
  println("Creating display: " + DISPLAY_WIDTH + "x" + DISPLAY_HEIGHT);
  size(DISPLAY_WIDTH, DISPLAY_HEIGHT);
  noSmooth();
  
  // ----------------------------------------------------
  // Pre-Process values & attributes
  build_gamma();
  
  // ----------------------------------------------------
  // Setup the Renderers
  renderers = new ArrayList();
  println("Creating renderers, this can take a few seconds...");
  
  // create color renderer
  rendererColor = new ColorRenderer(this, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
  renderers.add(rendererColor);
  
  // create disco renderer
  rendererDisco = new DiscoRenderer(this, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
  renderers.add(rendererDisco);
  
  // create video renderer
  rendererVideo = new VideoRenderer(this, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
  renderers.add(rendererVideo);
  
  // setup the renderer
  set_render_mode(0);
  
  // ---------------------------------------------------
  // Setup the serial comms
  if (ENABLE_SERIAL_COMMS) {
    println("Here are our serial ports:");
    println(Serial.list());
    serialConnection = new Serial(this, Serial.list()[6], 115200);
  }
}


// --------------------------------------------------------
// Run the Renderers & Generate output
void draw() {
  // clear the screen
  background(255,255,255);
  
  // create/activate and render the current visualiser
  current_renderer().draw(modifier_renderer);
  
  // Load the pixels
  loadPixels();
  
  // generate the histograms
  colorMode(RGB, 255);
  histogram = new int[3][256];
  for (int w = 0; w < VIDEO_WIDTH; w++) {
    for (int h = 0; h < VIDEO_HEIGHT; h++) {
      histogram[0][int(  red(get(w, h)))] ++;
      histogram[1][int(green(get(w, h)))] ++;
      histogram[2][int( blue(get(w, h)))] ++;
    }
  }
  
  // Histogram Logging
  if (VERBOSE) {
    for (int h = 0; h < 3; h++) {
      print("Histogram ");
      print(h);
      print(": ");
      for (int i=0; i < 255; i ++) {
        print(histogram[h][i]);
        print(",");
      }
      println("end");
    }
  }
  
  // what's the max overal channel value
  channel_max = max(max(histogram[0]), max(histogram[1]), max(histogram[2]));
  
  // draw the three histograms: R, G & B
  for (int h = 0; h < 3; h++) {
    // calc the top
    histogram_y = HISTOGRAM_HEIGHT * h;
    histogram_x = VIDEO_WIDTH;
    
    // draw the background
    if (h==0) fill(255, 0, 0);
    if (h==1) fill(0, 255, 0);
    if (h==2) fill(0, 0, 255);
    rect(histogram_x, histogram_y, HISTOGRAM_WIDTH, HISTOGRAM_HEIGHT);
    
    // draw the lines
    for (int i=0; i < 255; i ++) {
      int y = int(map(float(histogram[h][i]), 0.0, float(channel_max), 0.0, float(HISTOGRAM_HEIGHT)));
      line(histogram_x+i, histogram_y+HISTOGRAM_HEIGHT-y, histogram_x+i, histogram_y+HISTOGRAM_HEIGHT);
    }
  }
  
  // draw the ambient color range
  fill(255,125);
  stroke(0,0);
  rect(VIDEO_WIDTH+(HISTOGRAM_AMBIENT_LEVEL-(HISTOGRAM_AMBIENT_RANGE/2)), 0, HISTOGRAM_AMBIENT_RANGE, HISTOGRAM_HEIGHT*3);
  stroke(255,255);
  line(VIDEO_WIDTH+HISTOGRAM_AMBIENT_LEVEL, 0, VIDEO_WIDTH+HISTOGRAM_AMBIENT_LEVEL, HISTOGRAM_HEIGHT*3);
  
  // calc the ambient colour
  int r_total = 0;
  int g_total = 0;
  int b_total = 0;
  int position;
  for (int h=0; h<3; h++) {
    for (int range=0; range<HISTOGRAM_AMBIENT_RANGE; range++) {
      position = (HISTOGRAM_AMBIENT_LEVEL - (HISTOGRAM_AMBIENT_RANGE / 2)) + range;
      if (h==0) r_total += histogram[0][position];
      if (h==1) g_total += histogram[0][position];
      if (h==2) b_total += histogram[0][position];
    }
  }
  
  channel_max = max(r_total, g_total, b_total);
  int r = int(map(float(r_total), 0.0, float(channel_max), 0.0, 255.0));
  int g = int(map(float(g_total), 0.0, float(channel_max), 0.0, 255.0));
  int b = int(map(float(b_total), 0.0, float(channel_max), 0.0, 255.0));
  fill(r, g, b);
  stroke(0,255);
  rect(VIDEO_WIDTH, HISTOGRAM_HEIGHT*3,  HISTOGRAM_WIDTH, HISTOGRAM_HEIGHT);
  
  // make sure the color mode is correct
  colorMode(RGB, 100);
  
  // create the LED array
//  int pixel_colors_counter = 0;
//  byte[] pixel_colors = new byte[6 + (LED_COUNT*3)];
//  pixel_colors[pixel_colors_counter++] = 'A';
//  pixel_colors[pixel_colors_counter++] = 'd';
//  pixel_colors[pixel_colors_counter++] = 'a';
//  pixel_colors[pixel_colors_counter++] = byte((LED_COUNT - 1) >> 8);
//  pixel_colors[pixel_colors_counter++] = byte((LED_COUNT - 1) & 0xff);
//  pixel_colors[pixel_colors_counter++] = byte(pixel_colors[3] ^ pixel_colors[4] ^ 0x55);
  
  // We know how many pixels there are, so lets walk around the display
  // the first LED will be the North West pixel (top left corner of the screen)
  int row_id, column_id;
  int color_red, color_green, color_blue, merged_color, deficit;
  for (int pixel_id = 0; pixel_id < LED_COUNT; pixel_id ++) {
    // get the position & color for the LED
    int[] pixel_colrow = positionForLED(pixel_id);
    color pixel_color  = colorForLED(pixel_colrow[0], pixel_colrow[1]);
    
    // process the colour - and adjust the primary brightness to match the user setting
    color_red   = max(0, int(  red(pixel_color)) - (100 - modifier_brightness));
    color_green = max(0, int(green(pixel_color)) - (100 - modifier_brightness));
    color_blue  = max(0, int( blue(pixel_color)) - (100 - modifier_brightness));
    
    // ensure brightness
    if (current_renderer().shouldManageBrightness()) {
      merged_color = color_red + color_green + color_blue;
      if(merged_color < MIN_BRIGHTNESS) {
        if(merged_color == 0) {
          deficit = MIN_BRIGHTNESS / 3;
          color_red   += deficit;
          color_green += deficit;
          color_blue  += deficit;
        } else {
          deficit = MIN_BRIGHTNESS - merged_color;
          color_red   += deficit * (merged_color - color_red  ) / (merged_color * 2);
          color_green += deficit * (merged_color - color_green) / (merged_color * 2);
          color_blue  += deficit * (merged_color - color_blue ) / (merged_color * 2);
        }
      }
    }
    
    // draw it
    representLED(pixel_colrow[0], pixel_colrow[1], color(color_red, color_green, color_blue));
    
    // write the data to the array
    // pixel_colors[pixel_colors_counter++] = gamma[byte(  color_red)][0];
    // pixel_colors[pixel_colors_counter++] = gamma[byte(color_green)][1];
    // pixel_colors[pixel_colors_counter++] = gamma[byte( color_blue)][2];
//    pixel_colors[pixel_colors_counter++] = byte(  color_red);
//    pixel_colors[pixel_colors_counter++] = byte(color_green);
//    pixel_colors[pixel_colors_counter++] = byte( color_blue);
  }
  
  // Annndddd... Output!!!
//  if (VERBOSE) println(pixel_colors);
//  if (ENABLE_SERIAL_COMMS) serialConnection.write(pixel_colors);
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

// build our gamma index
void build_gamma() {
  float f;
  int i;
  for(i=0; i<256; i++) {
    f           = pow((float)i / 255.0, 2.8);
    gamma[i][0] = (byte)(f * 255.0);
    gamma[i][1] = (byte)(f * 240.0);
    gamma[i][2] = (byte)(f * 220.0);
  };
}

// ----------------------------------------------------
// IR Remote Simulation
void keyPressed(){
  switch(key) {
    case('w'):
      println("Brightness up");
      if (modifier_brightness < 100) modifier_brightness += 10;
      break;
    case('s'):
      println("Brightness down");
      if (modifier_brightness > 10) modifier_brightness -= 10;
      break;
      
    case('d'):
      println("Colour forward");
      modifier_renderer ++;
      if (modifier_renderer > 100) {
        modifier_renderer = 0;
      };
      break;
    case('a'):
      println("Colour back");
      modifier_renderer --;
      if (modifier_renderer < 0) {
        modifier_renderer = 100;
      };
      break;
    
    case(' '):
      println("Cycle render mode");
      next_render_mode();
      break;
      
    default:
      println("Not sure what '" + key + "' is meant to do?");
  }
}





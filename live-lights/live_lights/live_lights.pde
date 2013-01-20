// Renderer Super Class
class Renderer {
  Renderer() {
    // nada
  }
  boolean render() {
    return true;
  }
  void wake_up() {
    println("Wake Up");
  }
  void sleep() {
    println("Sleep");
  }
}

// ------------

// Display Settings
static final int   DISPLAY_WIDTH = 320;
static final float DISPLAY_RATIO = 16.0/9.0;
static final int   DISPLAY_FPS = 30;

// Renderers & Render Modes
int render_mode = 0;
ArrayList renderers;
Renderer rendererColor, rendererDisco, rendererVideo;

void setup() {
  // set up the screen real estate
  println("Creating display: " + DISPLAY_WIDTH + "x" + ceil(DISPLAY_WIDTH/DISPLAY_RATIO) + "@" + DISPLAY_FPS);
  size(DISPLAY_WIDTH, ceil(DISPLAY_WIDTH/DISPLAY_RATIO));
  frameRate(DISPLAY_FPS);
  
  // Setup our renderers
  renderers = new ArrayList();
  
  // create color renderer
  rendererColor = new Renderer();
  renderers.add(rendererColor);
  
  // create disco renderer
  rendererDisco = new Renderer();
  renderers.add(rendererDisco);
  
  // create video renderer
  rendererVideo = new Renderer();
  renderers.add(rendererVideo);
  
  // setup the renderer
  set_render_mode(0);
}

void draw() {
  // create/activate and render the current visualiser
}

void set_render_mode(int mode_index) {
  // tell the renderer to stop processing anything it might be processing
  current_renderer().sleep();
  
  // set the renderer
  render_mode = mode_index;
  
  // get it running
  current_renderer().wake_up();
}

Renderer current_renderer() {
  return (Renderer)renderers.get(render_mode);
}

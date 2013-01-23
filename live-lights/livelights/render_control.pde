// Set the Render mode
void set_render_mode(int mode_index) {
  // tell the renderer to stop processing anything it might be processing
  current_renderer().sleep();
  
  // set the renderer
  render_mode = mode_index;
  
  // get it running
  current_renderer().wake_up();
}

// cycle through the render modes
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

// ----------------------------------------------------------

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

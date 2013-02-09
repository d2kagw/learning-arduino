import pylirc, time, select, sys, Queue
from threading import Thread, Event

remote_commends_queue = Queue.Queue(maxsize=0)

# ------------------

class Remote(Thread):
  def __init__(self):
    Thread.__init__(self)
    self._stop = Event()
  
  def stop(self):
    self._stop.set()
  
  def stopped(self):
    return self._stop.isSet()
  
  def run(self):
    local_var = 0
    import time
    while not self.stopped():
      local_var += 1
      print "Process A is running"
      if local_var % 2 == 0:
        remote_commends_queue.put("silly method (even only)")
      time.sleep(1)
    
   
  

# ------------------

class Renderer(Thread):
  def __init__(self):
    Thread.__init__(self)
    self._stop = Event()
  
  def stop(self):
    self._stop.set()
  
  def stopped(self):
    return self._stop.isSet()
  
  def run(self):
    import time
    while not self.stopped():
      if remote_commends_queue.empty():
        print "Process B is running: no command"
      else:
        command = remote_commends_queue.get(False)
        print "Process B is running: %s" % command
      time.sleep(1)
    
  

# ------------------

remote = Remote()
renderer = Renderer()

def start_working():
  print "Starting workers..."
  remote.start()
  renderer.start()
  while True:
    time.sleep(1)
  

def stop_working():
  print "Stopping workers..."
  remote.stop()
  renderer.stop()

# -------------------

try:
  start_working()  
except (KeyboardInterrupt, SystemExit):
  stop_working()
  sys.exit()



import pylirc, time, select
from threading import Thread

conf = "./lirc.config"
blocking = 0;
code = ""

class Timer(Thread):
  def __init__(self):
    Thread.__init__(self)
    
  def run(self):
    import time
    i = 0
    while(i < 10):
      i = i + 1
      print "Time class is ticking..." + str(i)
      time.sleep(1)
      
    
   
  

class IRRec(Thread):
  def __init__(self, lirchandle):
    Thread.__init__(self)
    self.lirchandle = lirchandle
  
  def run(self):
    global code
    print "IRRrec awaits IR commands"
    
    if(select.select([self.lirchandle], [], [], 6) == ([], [], [])):
      print "IRRrec timed out"
    else:
      s = pylirc.nextcode()
      if(s):
        for code in s:
          print code
        
      
    
  

lirchandle = pylirc.init("pylirc", conf, blocking)
if(lirchandle):
  print "Succesfully opened lirc, handle is " + str(lirchandle)
  
  tim = Timer()
  tim.start()
  
  irrec = IRRec(lirchandle)
  irrec.start()
  
  code = ""
  while(code != "quit"):
    if(irrec.isAlive() == 0):
      irrec = IRRec(lirchandle)
      irrec.start()
    
    # Very intuitive indeed
    #if(not blocking):
    print "."
    
    # Delay...
    time.sleep(1)
    
  
  # Clean up lirc
  pylirc.exit()


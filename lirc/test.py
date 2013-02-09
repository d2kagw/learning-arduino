# https://github.com/scottjgibson/PixelPi

import pylirc, time
blocking = 1;
conf = "./lircrc"

if(pylirc.init("pylirc", conf, blocking)):
  code = {"config" : ""}
  while(code["config"] != "quit"):
    
    # Very intuitive indeed
    if(not blocking):
      print "."
      time.sleep(1)
    
    # Read next code
    s = pylirc.nextcode(1)
    
    while(s):
      for (code) in s:
        print "Command: %s, Repeat: %d" % (code["config"], code["repeat"])
        
        if(code["config"] == "blocking"):
          blocking = 1
          pylirc.blocking(1)
          
        elif(code["config"] == "nonblocking"):
          blocking = 0
          pylirc.blocking(0)
        
      # Read next code?
      if(not blocking):
        s = pylirc.nextcode(1)
      else:
        s = []
  
  # Clean up lirc
  pylirc.exit()
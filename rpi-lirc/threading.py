import time
from threading import Thread

global_var = "z"

class ProcessA(Thread):
  local_var = "x"
  def __init__(self):
    Thread.__init__(self)

  def run(self):
    import time
    print "Process A is running"
    time.sleep(1)



class ProcessB(Thread):
  local_var = "y"
  def __init__(self):
    Thread.__init__(self)

  def run(self):
    import time
    print "Process B is running"
    time.sleep(1)

# ------------------

procA = ProcessA()
procA.start()

procB = ProcessB()
procB.start()

# -------------------

while True:
  time.sleep(1)

#import <WProgram.h>

#ifndef _SingleTap
#define _SingleTap

  class SingleTap {
    public:
      SingleTap(int pin);
      boolean isHit();
    private:
      boolean _hasBeenRecorded;
  }

#endif

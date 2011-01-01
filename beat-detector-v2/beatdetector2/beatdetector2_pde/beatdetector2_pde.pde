/*
  Beat Detector v2
  
  Uses a push button to detect the beat through a users tapping rhythm.
  The code records the tap intervals and calculates the BPM, flashing an LED to the beat.
  
  Changes since v1:
  * simplified user interface, only one button for all operations
  * simplified code, uses libraries for BPM and Button control
  
  Details on the circuit can be found here:
  https://github.com/d2kagw/learning-arduino/tree/master/beat-detector-v2
  
  Created 2/1/11 by Aaron Wallis
*/

#import <SingleTap.h>

## DC Motor Control

<!-- <object width="600" height="362"><param name="movie" value="<youtube path>"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="<youtube path>" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="600" height="362"></embed></object> -->

I'm currently working on a Laser Projector, I'm starting with something basic (i.e. a projector that draws 'flower' like patterns to the beat).
Obviously, one of the requirements for the projector is motor control, so this was my first attempt at using a H-Bridge.

It's a very simple project, but was a great way to learn how a H-Bridge works, and more importantly, how to get the Arduino to control the speed and direction of the motors.

Note: there are plenty of motor control libraries out there, but I ended up going the manual route to make sure I got a full understanding of what goes on inside.

## What you'll need

* Arduino Uno
* Breadboard
* 1x 9V Battery (or whatever your motors need to work)
* 2x DC Motor 
* 1x 10µF Capacitor
* 1x L293D H-Bridge

## Sketch
<img src="https://github.com/d2kagw/learning-arduino/raw/master/dc-motor-control/fritzing.png" width="600px" alt="DC Motor Control" title="DC Motor Control"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](https://github.com/d2kagw/learning-arduino/raw/master/dc-motor-control/dc-motor-control.fz).

## Code

    int curspeed = 0;
    int fadeAmount = 5;
    int limitting = 225;
    
    int PIN_DIR = 10;
    int PIN_PWM =  9;
    
    void setup()  { 
      pinMode(PIN_DIR, OUTPUT);
      pinMode(PIN_PWM, OUTPUT);
      
      Serial.begin(9600);
    } 
    
    void loop()  { 
      digitalWrite(PIN_DIR, HIGH);
      analogWrite(PIN_PWM, curspeed);
      
      curspeed = curspeed + fadeAmount;
      
      Serial.println(curspeed);
      
      if (curspeed == 0 || curspeed == limitting) {
        fadeAmount = -fadeAmount ; 
      }
      
      delay(50);
    }


**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](https://github.com/d2kagw/learning-arduino/raw/master/dc-motor-control/dcmotorcontrol/dcmotorcontrol.pde).

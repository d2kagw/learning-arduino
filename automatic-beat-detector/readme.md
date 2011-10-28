## Automatic Beat Detector

<!-- <object width="600" height="362"><param name="movie" value="<youtube path>"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="<youtube path>" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="600" height="362"></embed></object> -->

Almost a year ago I designed & constructed a very simple beat detector using the Arduino Uno.
It used two buttons which the user would tap along with the beat, from that, the Arduino would determine the 'BPM' and adjust its timing to suit.

Although it was very accurate and led to some impressive results (see the [project post here](http://learning-arduino.tumblr.com/post/2579172342/arduino-led-bar-with-rhythm-detection)) I've been toying with the idea of the Arduino being able to work out the rhythm itself.

This was my first stab at a automatic solution.

Overall, I'm not satisfied with the result, but it's a decent stepping stone.

What I've done is throw an Electret Mic and OpAmp together with the output feeding into an Analog input of the Arduino.

## What you'll need

* Arduino Uno
* Breadboard
* 5x 220Ω Resistor
* 2x 4.7µF Capacitor
* 1x LM358 Dual Op-Amp
* 1x Electret Microphone
* 1x LED
* 1x 100kΩ Potentiometer (may need to up this depending on your implementation)

## Sketch
<img src="<image path>" width="600px" alt="<project name>" title="<project name>"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](<fritzing path>).

## Code

    <code>

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](<code path>).

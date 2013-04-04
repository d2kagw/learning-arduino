# Lirc & RaspberryPi

## Installing

Install the libraries:
    
    sudo apt-get install -y lirc python-pylirc python-cwiid

Test that they work by running these commands and pushing some remote buttons:
    
    sudo modprobe lirc_rpi
    sudo mode2 -d /dev/lirc0

Throw in the hardware conf:

    sudo tee <<EOF
    # /etc/lirc/hardware.conf
    #
    # Arguments which will be used when launching lircd
    LIRCD_ARGS="--uinput"

    #START_LIRCMD=false
    #START_IREXEC=false

    LOAD_MODULES=true

    # Run "lircd --driver=help" for a list of supported drivers.
    DRIVER="default"
    # usually /dev/lirc0 is the correct setting for systems using udev 
    DEVICE="/dev/lirc0"
    MODULES="lirc_rpi"

    # Default configuration files for your hardware if any
    LIRCD_CONF=""
    LIRCMD_CONF=""
    EOF    

And restart the lib:
    
    /etc/init.d/lirc restart

Give it a test:
    
    

<project description>

## What you'll need

* Arduino Uno
* Breadboard
* <project requirements>

**Note:** almost all the projects I put together use the [SparkFun Arduino UNO Inventors Kit](http://www.sparkfun.com/products/10173) and [SparkFun Beginner Parts Kit](http://www.sparkfun.com/products/10003) which you can buy at [ToysDownUnder.com](http://toysdownunder.com/arduino).

## Sketch
<img src="<image path>" width="600px" alt="<project name>" title="<project name>"/ >

**Note:** you can download the [Fritzing](http://fritzing.org/) file [here](<fritzing path>).

## Code

    <code>

**Note:** you can download the [Arduino](http://www.arduino.cc/en/Main/Software) source code from [here](<code path>).

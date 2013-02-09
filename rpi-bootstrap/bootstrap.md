# Basic Bootstrap for RaspberryPi

## Copy the Disk Image
    
    sudo diskutil unmount /dev/disk1s1
    sudo dd bs=1m if=~/Downloads/2012-12-16-wheezy-raspbian.img of=/dev/rdisk1
    sudo diskutil eject /dev/rdisk1

## SSH

After finding the IP address, SSH in.
Remember that the password (unless changed) is `raspberry`
    
    ssh pi@xxx.xxx.xxx.xxx

## Setup the machine
    
    sudo raspi-config
    
When you're in there:

- resize the boot partition
- enable en\_AU, en\_US & en\_UK locales (default to en\_US.utf8)
- set the timezone
- set startup to boot into desktop

Then do an update, upgrade and install some base packages:
    
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y git git-core curl subversion vim build-essential python ruby1.9.1
    
Update the firmware:
    
    sudo wget http://goo.gl/1BOfJ -O /usr/bin/rpi-update && sudo chmod +x /usr/bin/rpi-update
    sudo apt-get install -y git-core
    sudo rpi-update

And install devtools:
    
    sudo apt-get install -y python-rpi.gpio zlib1g-dev libssl-dev


## Set up x11vnc to start on boot

This guy will either use the display we've got, or create a new one for VNC connections
    
    sudo apt-get install x11vnc -y
    x11vnc -storepasswd # set it to raspberr
    
    sudo tee /etc/init.d/x11vnc <<EOF
    #!/bin/sh
    #
    # /etc/init.d/vnc
    #
    ### BEGIN INIT INFO
    # Provides:          x11vnc server
    # Required-Start:    xdm
    # Should-Start: 
    # Required-Stop: 
    # Should-Stop: 
    # Default-Start:     5
    # Default-Stop:      0 1 2 6
    # Short-Description: 
    # Description:       Start or stop vnc server
    ### END INIT INFO

    #INIT SCRIPT VARIABLES
    SERVICE=$(basename $0)
    PIDFILE="/var/run/${SERVICE}.pid"
    BIN="/usr/bin/x11vnc "
    AUTH=`ps wwaux | grep '/X.*-auth' | grep -v grep | sed -e 's/^.*-auth *//' -e 's/ .*$//' | head -n 1`
    OPT="-display :0 -auth ${AUTH} -nopw -unixpw -shared -oa /var/log/vnc.log -xkb -bg -verbose  "
    CMD=${BIN}${OPT}

    . /lib/lsb/init-functions

    # Reset status of this service
    rc_reset

    case "$1" in
        start)
        echo -n "Starting ${SERVICE}..."
            ## Start daemon with startproc(8). 
        /sbin/startproc ${CMD}
        sleep 2s
        # Remember status and be verbose.
            rc_status -v
        ;;
        *)
        echo -e "Usage: ${SERVICE} {start}"
        exit 1
        ;;
    esac
    rc_exit
    EOF
    
    sudo chmod 755 /etc/init.d/x11vnc
    sudo touch /var/log/x11vnc.log
    sudo chmod 777 /var/log/x11vnc.log
    sudo update-rc.d x11vnc defaults

## Setting up File & Screen Sharing for Mac awesomeness:
    
    sudo apt-get install netatalk avahi-daemon -y
    sudo update-rc.d avahi-daemon defaults

    sudo tee /etc/avahi/services/afpd.service <<EOF
    <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
       <name replace-wildcards="yes">%h</name>
       <service>
          <type>_afpovertcp._tcp</type>
          <port>548</port>
       </service>
    </service-group>
    EOF

    sudo tee /etc/avahi/services/rfb.service <<EOF
    <?xml version="1.0" standalone='no'?>
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
      <name replace-wildcards="yes">%h</name>
      <service>
        <type>_rfb._tcp</type>
        <port>5900</port>
      </service>
    </service-group>
    EOF

    sudo /etc/init.d/avahi-daemon restart


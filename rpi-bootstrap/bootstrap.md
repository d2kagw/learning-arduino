# Basic Bootstrap for RaspberryPi

## Copy the Disk Image
    
    sudo diskutil unmount /dev/disk1s1
    sudo dd bs=1m if=~/Downloads/2012-12-16-wheezy-raspbian.img of=/dev/rdisk1
    sudo diskutil eject /dev/rdisk1

## SSH

After finding the IP address, SSH in.
Remember that the password (unless changed) is `raspberry`
    
    ssh pi@xxx.xxx.xxx.xxx
    ssh pi@192.168.2.17

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
    
Then run this sexy mumma:

    sudo wget http://goo.gl/1BOfJ -O /usr/bin/rpi-update && sudo chmod +x /usr/bin/rpi-update
    sudo rpi-update
    
    sudo apt-get install -y python-rpi.gpio zlib1g-dev libssl-dev


## Set up x11vnc to start on boot

This guy will either use the display we've got, or create a new one for VNC connections
    
    sudo apt-get install x11vnc -y
    x11vnc -storepasswd # set it to raspberr
    
    sudo su
    cat >/etc/init.d/x11vnc <<EOL
    #!/bin/sh
    ### BEGIN INIT INFO
    # Provides:          x11vnc
    # Required-Start:    $local_fs
    # Required-Stop:     $local_fs
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Start/stop x11vnc
    ### END INIT INFO
 
    export USER='pi'
 
    eval cd ~$USER
 
    case "$1" in
      start)
        su $USER -c '/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -auth guess -create -display :0 -passwd 'raspberr' -forever -bg -o /var/log/x11vnc.log'
        echo "Starting x11vnc server for $USER "
        ;;
      stop)
        x11vnc -R stop
        echo "x11vnc stopped"
        ;;
      *)
        echo "Usage: /etc/init.d/x11vnc {start|stop}"
        exit 1
        ;;
    esac
    exit 0
    EOL
    exit
    
    sudo chmod 755 /etc/init.d/x11vnc
    sudo update-rc.d x11vnc default

## Setting up File & Screen Sharing for Mac awesomeness:
    
    sudo apt-get install netatalk avahi-daemon -y
    sudo update-rc.d avahi-daemon defaults
    
    sudo vim /etc/avahi/services/afpd.service
    
    # this is the contents for the file
    <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
       <name replace-wildcards="yes">%h</name>
       <service>
          <type>_afpovertcp._tcp</type>
          <port>548</port>
       </service>
    </service-group>
    
    sudo vim /etc/avahi/services/rfb.service
    
    # this is the contents for the file
    <?xml version="1.0" standalone='no'?>
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
      <name replace-wildcards="yes">%h</name>
      <service>
        <type>_rfb._tcp</type>
        <port>5901</port>
      </service>
    </service-group>
    
    sudo /etc/init.d/avahi-daemon restart


## Setting up Geckoboard
    
    sudo apt-get install -y chromium-browser chromium-browser-l10n ttf-mscorefonts-installer
    echo "[Desktop Entry]" >> ~/.config/autostart/geckoboard.desktop
    echo "Encoding=UTF-8" >> ~/.config/autostart/geckoboard.desktop
    echo "Type=Application" >> ~/.config/autostart/geckoboard.desktop
    echo "Name=Geckoboard" >> ~/.config/autostart/geckoboard.desktop
    echo "Comment=" >> ~/.config/autostart/geckoboard.desktop
    echo "Exec=/usr/bin/chromium-browser – -kiosk" >> ~/.config/autostart/geckoboard.desktop
    echo "StartupNotify=false" >> ~/.config/autostart/geckoboard.desktop
    echo "Terminal=false" >> ~/.config/autostart/geckoboard.desktop
    echo "Hidden=false" >> ~/.config/autostart/geckoboard.desktop




---

## Good Articles

- [Setup screen sharing](http://4dc5.com/2012/06/12/setting-up-vnc-on-raspberry-pi-for-mac-access/)
- [Geckoboard](http://www.geckoboard.com/geckopi-run-geckoboard-on-a-raspberry-pi/)


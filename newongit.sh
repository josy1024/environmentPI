
## HARDWARE PIN MAPPING!!

#wireing: PI:
# http://projects.drogon.net/raspberry-pi/wiringpi/pins/

## wire1: w1 temperatur
# GPIO3 22 (1wire temp sensor)

## 433 send + receive
# GPIO0 17 433 receive	(sniffer)
# GPIO4	23 433 send (send)

## am2302 feuchte + temperatur sensor

# GPIO7 am2302 lol_dht22 

# USB?

#git in "primary codebase"

git commit -m 'init import'
git config --global user.email "josy1024@gmail.com"
git config --global user.name "josy1024"
git commit -m 'init import'
git remote add origin https://github.com/josy1024/environmentPI.git
git pull origin master
git push origin master


#compiler basics!

apt-get install make gcc
apt-get install build-essential


#
# store credentials!
git config credential.helper store

cd /opt
#git bash added git repository
git clone https://github.com/josy1024/environmentPI.git temp

## w1 temperatur

#/boot/config.txt
dtoverlay=w1-gpio,gpiopin=22,pullup=on

#/etc/modules
wire
w1-gpio
w1-therm


# 433, GPIO TEMP, airusb
# 433 tools
# http://tutorials-raspberrypi.de/raspberry-pis-ueber-433mhz-funk-kommunizieren-lassen/
# http://tutorials-raspberrypi.de/raspberry-pi-funksteckdosen-433-mhz-steuern/


# COMPILE: wireingpi
cd /opt
git clone git://git.drogon.net/wiringPi && 

cd wiringPi &&./build



#433utils (wireingpi needed!)
cd /opt
git clone https://github.com/ninjablocks/433Utils.git --recursive

cd 433Utils/RPi_utils
make all

# programs:
# /opt/433Utils/RPi_utils/send

sudo visudo
Die Zeile einfügen:
www-data ALL=NOPASSWD:/opt/433Utils/RPi_utils/send

#am2302 temp sensor  (wireingpi needed!)
# https://www.kernel-error.de/kernel-error-blog/302-temperaturmessung-mit-dem-raspberry-pi-und-dem-dht22
mkdir /opt/am2302
/opt/am2302/lol_dht22/loldht

git clone https://github.com/technion/lol_dht22
$ cd lol_dht22
$ ./configure
$ make

sudo apt-get install libusb-dev

mkdir /opt/airsensor
cd /opt/airsensor 
wget https://raw.githubusercontent.com/jschanz/usb-sensors-linux/master/airsensor/airsensor.c

gcc -o airsensor airsensor.c -lusb
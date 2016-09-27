#!/usr/bin/python
# -*- coding: utf-8 -*-

import re, os, rrdtool, time

# function: read and parse sensor data file
def read_sensor(path):
  value = "U"
  try:
    f = open(path, "r")
    line = f.readline()
    if re.match(r"([0-9a-f]{2} ){9}: crc=[0-9a-f]{2} YES", line):
      line = f.readline()
      m = re.match(r"([0-9a-f]{2} ){9}t=([+-]?[0-9]+)", line)
      if m:
        value = str(float(m.group(2)) / 1000.0)
    f.close()
  except (IOError), e:
    print time.strftime("%x %X"), "Error reading", path, ": ", e
  return value


def read_file(path):
  value = "U"
  try:
    f = open(path, "r")
    line = f.readline()
    value = str(float(line) )
    #value = str(float(line) / 1000.0)
    f.close()
  except (IOError), e:
    print time.strftime("%x %X"), "Error reading", path, ": ", e
  return value


# define pathes to 1-wire sensor data
pathes = (
  "/sys/bus/w1/devices/10-0008028ea37b/w1_slave",
#  "/sys/bus/w1/devices/10-000801b5959d/w1_slave"
)

# read sensor data
data = 'N'
for path in pathes:
  data += ':'
  data += read_sensor(path)
  time.sleep(1)

# insert data into round-robin-database
rrdtool.update(
  "%s/temperature.rrd" % (os.path.dirname(os.path.abspath(__file__))),
  data)


import subprocess

# get the data and write them to .txt files
subprocess.call("/opt/temp/am2302.sh")

patham2302 = (
  "/opt/data/dht_gpio7_temp.txt",
  "/opt/data/dht_gpio7_hum.txt",
)

# update rrd file for am2302
data = 'N'
for path in patham2302:
  data += ':'
  data += read_file(path)

rrdtool.update(
  "%s/am2302.rrd" % (os.path.dirname(os.path.abspath(__file__))),
  data)

#airsensornofify telegram 

subprocess.call("/opt/temp/airsensor.sh")
pathairsensor = (
  "/opt/data/airsensor.txt",
  "/opt/data/dht_gpio7_hum.txt",
  "/opt/data/dht_gpio7_temp.txt",
)

# update rrd file for airsensor
try:
  data = 'N'
  for path in pathairsensor:
    data += ':'
    data += read_file(path)

  rrdtool.update(
    "%s/airsensor.rrd" % (os.path.dirname(os.path.abspath(__file__))),
    data)
    
finally:  
  # CALL xivley update script for the data
  subprocess.call("/opt/xively_tutorial/crontab.sh")

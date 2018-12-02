#!/usr/bin/env python3

# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2

#FEED_ID=xxx API_KEY=key DEBUG=false python /opt/tuto ial/temp1.py >/dev/null
#FEED_ID=xxx API_KEY=key DEBUG=false 
# python /opt/temp/cron/adafruit.py >/dev/null


import os
import subprocess
import time
import datetime
import requests

# extract feed_id and api_key from environment variables
FEED_ID = os.environ["IO_USERNAME"]
IO_KEY = os.environ["IO_KEY"]
DEBUG = os.environ["DEBUG"] or false

# ? getting error!
# Import library and create instance of REST client.
from Adafruit_IO import Client
aio = Client(FEED_ID, IO_KEY)

# function to read 1 minute load average from system uptime command
def read_sensorhum():
  if DEBUG:
    print ("Reading hum")
  return subprocess.check_output(["cat /opt/data/dht_gpio7_hum.txt|tr -d '\n'"], shell=True)

def read_sensortemp():
  if DEBUG:
    print ("Reading temp")
#  return subprocess.check_output(["rrdtool lastupdate /opt/temp/temperature.rrd | tail -1 | /usr/bin/awk '{print $2}'"], shell=True)
  return subprocess.check_output(["cat /opt/data/dht_gpio7_temp.txt|tr -d '\n'"], shell=True)
  
def read_sensorair():
  if DEBUG:
    print ("Reading air")
#  return subprocess.check_output(["rrdtool lastupdate /opt/temp/temperature.rrd | tail -1 | /usr/bin/awk '{print $2}'"], shell=True)
  return subprocess.check_output(["cat /opt/data/airsensor.txt|tr -d '\n'"], shell=True)
  

# main program entry point
# current 1 minute load average
def run():
  print ("Starting adafruit.py script")

  # ein prozent!!
  compareprozentair = 0.01
  compareprozent = 0.008

  oldsensor = 0

  sensor = str(read_sensortemp())
  sensorhum = str(read_sensorhum())
  sensorair = str(read_sensorair())

  # Add the value 98.6 to the feed 'Temperature'.
  #aio.send('temp', sensor)
  #aio.send('hum', sensorhum)
  #aio.send('air', sensorair)


  filever = "dht_gpio7_temp.txt"
  try:
    file = open('/opt/data/' + filever + '.sent', 'r')
    oldsensor = file.readline()
  except:
    pass
  
  try:
    comparevalue = abs( (float(sensor) - float(oldsensor)) / float(sensor) )
  except:
    comparevalue = 1
  
  if comparevalue > compareprozent:
    if DEBUG:
      print("Updating temp feed with value: %s old %s  " % (sensor, oldsensor))
    try:
      aio.send('temp', str(sensor))
      file = open('/opt/data/' + filever + '.sent', "w")
      file.write(sensor)
      file.close()
    except requests.HTTPError as e:
      print ("HTTPError({0}): {1}".format(e.errno, e.strerror))
  else:
    if DEBUG:
      print ("minimal change: %s " % comparevalue )

  filever = 'dht_gpio7_hum.txt'
  try:
    file = open('/opt/data/' + filever + '.sent', 'r')
    oldsensor = file.readline() 
  except:
    pass
  
  
  try:
    comparevalue = abs( (float(sensorhum) - float(oldsensor)) / float(sensorhum) )
  except:
    comparevalue = 1

  if comparevalue > compareprozent:
    if DEBUG:
      print ("Updating hum feed with value: %s old %s  " % (sensorhum, oldsensor))

    try:
      aio.send('hum', str(sensorhum))
      file = open('/opt/data/' + filever + '.sent', "w")
      file.write(sensorhum)
      file.close()
    except requests.HTTPError as e:
      print ("HTTPError({0}): {1}".format(e.errno, e.strerror))
  else:
    if DEBUG:
      print ("minimal change: %s " % comparevalue )

  filever = 'airsensor.txt'
  try:
    file = open('/opt/data/' + filever + '.sent', 'r')
    oldsensor = file.readline()
  except:
    pass

  if float(sensorair) > 10:
    try:
      comparevalue = abs( (float(sensorair) - float(oldsensor)) / float(sensorair) )
    except:
      comparevalue = 1

    if comparevalue > compareprozentair:
      if DEBUG:
        print ("Updating air  feed with value: %s old %s  " % (sensorair, oldsensor))

      try:
        aio.send('air', str(sensorair))
        file = open('/opt/data/' + filever + '.sent', "w")
        file.write(sensorair)
        file.close()
      except requests.HTTPError as e:
        print ("HTTPError({0}): {1}".format(e.errno, e.strerror))
    else:
      if DEBUG:
        print ("minimal change: %s " % comparevalue )

run()

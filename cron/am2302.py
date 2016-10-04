#!/usr/bin/env python

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

#source /opt/xively_tutorial/.envs/venv/bin/activate

# aufruf ueber crontab:
#FEED_ID=xxx API_KEY=key DEBUG=false python /opt/xively_tutorial/temp1.py >/dev/null
#FEED_ID=xxx API_KEY=key DEBUG=false python /opt/temp/cron/am2302.py >/dev/null


import os
import xively
import subprocess
import time
import datetime
import requests

# extract feed_id and api_key from environment variables
FEED_ID = os.environ["FEED_ID"]
API_KEY = os.environ["API_KEY"]
DEBUG = os.environ["DEBUG"] or false

# initialize api client
api = xively.XivelyAPIClient(API_KEY)

# function to read 1 minute load average from system uptime command
def read_sensorhum():
  if DEBUG:
    print "Reading hum" 
#  return subprocess.check_output(["rrdtool lastupdate /opt/temp/temperature.rrd | tail -1 | /usr/bin/awk '{print $2}'"], shell=True)
  return subprocess.check_output(["cat /opt/data/dht_gpio7_hum.txt"], shell=True)
#  return subprocess.check_output(["awk '{print $1}' /proc/loadavg"], shell=True)

def read_sensortemp():
  if DEBUG:
    print "Reading temp"
#  return subprocess.check_output(["rrdtool lastupdate /opt/temp/temperature.rrd | tail -1 | /usr/bin/awk '{print $2}'"], shell=True)
  return subprocess.check_output(["cat /opt/data/dht_gpio7_temp.txt"], shell=True)
  
def read_sensorair():
  if DEBUG:
    print "Reading air"
#  return subprocess.check_output(["rrdtool lastupdate /opt/temp/temperature.rrd | tail -1 | /usr/bin/awk '{print $2}'"], shell=True)
  return subprocess.check_output(["cat /opt/data/airsensor.txt"], shell=True)
  
#
# function to return a datastream object. This either creates a new datastream,
# or returns an existing one
def get_datastream(feed):
  try:
    datastream = feed.datastreams.get("Temperatur_am2302")
    if DEBUG:
      print "Found existing datastream"
    return datastream
  except:
    if DEBUG:
      print "Creating new datastream"
    datastream = feed.datastreams.create("Temperatur_am2302", tags="temp")
    return datastream


def get_datastreamhum(feed):
  try:
    datastream = feed.datastreams.get("Feuchte_am2302")
    if DEBUG:
      print "Found existing datastream"
    return datastream
  except:
    if DEBUG:
      print "Creating new datastream"
    datastream = feed.datastreams.create("Feuchte_am2302", tags="hum")
    return datastream

def get_datastreamair(feed):
  try:
    datastream = feed.datastreams.get("airsensor")
    if DEBUG:
      print "Found existing datastream"
    return datastream
  except:
    if DEBUG:
      print "Creating new datastream"
    datastream = feed.datastreams.create("airsensor", tags="air")
    return datastream


# main program entry point - runs continuously updating our datastream with the
# current 1 minute load average
def run():
  print "Starting Xively tutorial script"

  # ein prozent!!
  compareprozent = 0.01
  feed = api.feeds.get(FEED_ID)
  oldsensor = "0"
  datastream = get_datastream(feed)
  datastream.max_value = None
  datastream.min_value = None

  sensor = read_sensortemp()
  sensorhum = read_sensorhum()
  sensorair = read_sensorair()

  filever = "dht_gpio7_temp.txt"
  try:
    file = open('/opt/data/' + filever + '.sent', 'r')
    oldsensor = file.readline()
  except:
    pass

  comparevalue = abs( (float(sensor) - float(oldsensor)) / float(sensor) )
  if comparevalue > compareprozent:
    if DEBUG:
      print("Updating Xively temp feed with value: %s old %s  " % (sensor, oldsensor))
    datastream.current_value = sensor
    datastream.at = datetime.datetime.utcnow()
    try:
      datastream.update()
      file = open('/opt/data/' + filever + '.sent', "w")
      file.write(datastream.current_value)
      file.close()
    except requests.HTTPError as e:
      print "HTTPError({0}): {1}".format(e.errno, e.strerror)
  else:l
    if DEBUG:
      print ("minimal change:" + comparevalue

  datastreamhum = get_datastreamhum(feed)
  datastreamhum.max_value = None
  datastreamhum.min_value = None

  filever = 'dht_gpio7_hum.txt'
  try:
    file = open('/opt/data/' + filever + '.sent', 'r')
    oldsensor = file.readline()
  except:
    pass
  
  comparevalue = abs( (float(sensorhum) - float(oldsensor)) / float(sensorhum) )
  if comparevalue > compareprozent:
    if DEBUG:
      print ("Updating Xively hum  feed with value: %s old %s  " % (sensorhum, oldsensor))
    datastreamhum.current_value = sensorhum
    datastreamhum.at = datetime.datetime.utcnow()
    try:
      datastreamhum.update()
      file = open('/opt/data/' + filever + '.sent', "w")
      file.write(datastreamhum.current_value)
      file.close()
    except requests.HTTPError as e:
      print "HTTPError({0}): {1}".format(e.errno, e.strerror)
  else:
    if DEBUG:
      print ("minimal change:" + comparevalue

  datastreamair = get_datastreamair(feed)
  datastreamair.max_value = None
  datastreamair.min_value = None

  filever = 'airsensor.txt'
  try:
    file = open('/opt/data/' + filever + '.sent', 'r')
    oldsensor = file.readline()
  except:
    pass

  if float(sensorair) > 10:
    comparevalue = abs( (float(sensorair) - float(oldsensor)) / float(sensorair) )
    if comparevalue > compareprozent:
      if DEBUG:
        print ("Updating Xively air  feed with value: %s old %s  " % (sensorair, oldsensor))

      datastreamair.current_value = sensorair
      datastreamair.at = datetime.datetime.utcnow()
      try:
        datastreamair.update()
        file = open('/opt/data/' + filever + '.sent', "w")
        file.write(datastreamair.current_value)
        file.close()
      except requests.HTTPError as e:
        print "HTTPError({0}): {1}".format(e.errno, e.strerror)
    else:
      if DEBUG:
        print ("minimal change:" + comparevalue
#    time.sleep(10)

run()

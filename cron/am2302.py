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

  feed = api.feeds.get(FEED_ID)

  datastream = get_datastream(feed)
  datastream.max_value = None
  datastream.min_value = None

  sensor = read_sensortemp()
  sensorhum = read_sensorhum()
  sensorair = read_sensorair()

  if DEBUG:
    print "Updating Xively feed with value: %s" % sensor
    print "Updating Xively feed with value: %s" % sensorhum

  datastream.current_value = sensor
  datastream.at = datetime.datetime.utcnow()
  try:
    datastream.update()
  except requests.HTTPError as e:
    print "HTTPError({0}): {1}".format(e.errno, e.strerror)

  datastreamhum = get_datastreamhum(feed)
  datastreamhum.max_value = None
  datastreamhum.min_value = None


  datastreamhum.current_value = sensorhum
  datastreamhum.at = datetime.datetime.utcnow()
  try:
    datastreamhum.update()
  except requests.HTTPError as e:
    print "HTTPError({0}): {1}".format(e.errno, e.strerror)


  datastreamair = get_datastreamair(feed)
  datastreamair.max_value = None
  datastreamair.min_value = None


  datastreamair.current_value = sensorair
  datastreamair.at = datetime.datetime.utcnow()
  try:
    datastreamair.update()
  except requests.HTTPError as e:
    print "HTTPError({0}): {1}".format(e.errno, e.strerror)
    
#    time.sleep(10)

run()
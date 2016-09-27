#!/bin/bash
#Scriptname: start_cron.sh
 
#  */10 5-23 * * * /opt/temp/cron/start_cron.sh  >/dev/null

/opt/temp/cron/am2302.sh
/opt/temp/cron/airsensor.sh


##push /opt/data values to xively
/opt/secure/xively.sh

#!/bin/bash
#source /opt/xively_tutorial/.envs/venv/bin/activate

#FEED_ID=xxx API_KEY=key DEBUG=false python /opt/temp/cron/am2302.py >/dev/null
#FEED_ID=xxx API_KEY=key DEBUG=false python /opt/xively_tutorial/temp1.py >/dev/null

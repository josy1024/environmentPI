#!/bin/bash
#Scriptname: start_cron.sh

# execute right for script:
# git update-index --chmod=+x start_cron.sh

#  */10 5-23 * * * /opt/temp/cron/start_cron.sh  >/dev/null




/opt/temp/cron/am2302.sh
/opt/temp/cron/airsensor.sh

#/opt/temp/cron/webcam.sh


##push /opt/data values to xively
/opt/secure/xively.sh

#RUFT dann /opt/temp/cron/am2302.py auf!
#!/bin/bash
#source /opt/xively_tutorial/.envs/venv/bin/activate
#FEED_ID=xxx API_KEY=key DEBUG=false DEBUG=false python /opt/temp/cron/am2302.py

/opt/temp/cron/webcam.sh

#!/bin/bash
#Scriptname: am2302.sh
 
# based on: https://klenzel.de/1827
TEMPDIR=/opt/temp

/opt/airsensor/./airsensor -o -v >  $TEMPDIR/airsensor.txt

VALUE=`cat $TEMPDIR/airsensor.txt`


if [ "${VALUE}" -gt "1300" ]; then
    /usr/bin/php /opt/temp/bot/tele.php "bitte lueften luft schlecht ${VALUE}"
fi


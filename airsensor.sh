#!/bin/bash
#Scriptname: am2302.sh
 
# based on: https://klenzel.de/1827
TEMPDIR=/opt/temp

/opt/airsensor/./airsensor -o -v >  $TEMPDIR/airsensor.txt

VALUE=`cat $TEMPDIR/airsensor.txt`

if [ $(echo "if (${VALUE} > 500) 1 else 0" | bc) -eq 1 ]; then
    /usr/bin/php /opt/temp/bot/tele.php "bitte lueften luft schlecht ${VALUE}"
fi


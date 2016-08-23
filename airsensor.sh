#!/bin/bash
#Scriptname: am2302.sh
 
# based on: https://klenzel.de/1827
TEMPDIR=/opt/temp

/opt/airsensor/./airsensor -o -v >  $TEMPDIR/airsensor.txt

VALUE=`cat $TEMPDIR/airsensor.txt`
VAL_AIR=$VALUE
VALUE=`cat $TEMPDIR/dht_gpio7_temp.txt`
VALUE=${VALUE/.*}
VAL_TEMP=$VALUE

VALUE=`cat $TEMPDIR/dht_gpio7_hum.txt`
VALUE=${VALUE/.*}
VAL_HUM=$VALUE

MESSAGE="A: ${VAL_AIR}, T: ${VAL_TEMP}, H: ${VAL_HUM}"

STATEFILE=$TEMPDIR/airsensor.high

# hysterese ab 1300, unter 1000 entwarnung
if [ "${VAL_AIR}" -gt "1300" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "bitte lueften luft schlecht! ${MESSAGE}"
        touch $STATEFILE
    fi
fi

if [ "${VAL_AIR}" -lt "1000" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Luft erholt sich ;-) ${MESSAGE}"
        /bin/rm $STATEFILE
    fi
fi


STATEFILE=$TEMPDIR/dht_gpio7_temp.high

#temperatur 22-24
if [ "${VAL_TEMP}" -gt "24" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Temp erreicht! ${MESSAGE}"
        touch $STATEFILE
    fi
fi

if [ "${VAL_TEMP}" -lt "22" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Temp wieder OK ;-) ${MESSAGE}"
        /bin/rm $STATEFILE
    fi
fi


STATEFILE=$TEMPDIR/dht_gpio7_hum.high

#humidy
if [ "${VAL_HUM}" -gt "55" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Feuchte Klima OK ;-) ${MESSAGE}"
        touch $STATEFILE
    fi
fi

if [ "${VAL_HUM}" -lt "50" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Feuchte gering! ${MESSAGE}"
        /bin/rm $STATEFILE
    fi
fi

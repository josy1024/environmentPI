#!/bin/bash
#Scriptname: airsensor.sh
 
# based on: https://klenzel.de/1827
TEMPDIR=/opt/data
BOT=/opt/temp/bot

/opt/airsensor/./airsensor -o -v >  $TEMPDIR/airsensor.txt

# /opt/temp/cron/am2302.sh

VALUE=`cat $TEMPDIR/airsensor.txt`
VAL_AIR=$VALUE
VALUE=`cat $TEMPDIR/dht_gpio7_temp.txt`
VALUE=${VALUE/.*}
VAL_TEMP=$VALUE

VALUE=`cat $TEMPDIR/dht_gpio7_hum.txt`
VALUE=${VALUE/.*}
VAL_HUM=$VALUE

MESSAGE="A: ${VAL_AIR}, T: ${VAL_TEMP}, H: ${VAL_HUM}"
echo $MESSAGE

STATEFILE=$TEMPDIR/sendstatus

if [ ! -e "$STATEFILE" ]; then
    /usr/bin/php $BOT/tele.php "${MESSAGE} I'm online :-)"
    touch $STATEFILE
fi


if [ "${VAL_AIR}" -gt "100" ]; then
    STATEFILE=$TEMPDIR/airsensor.high
# hysterese ab 1300, unter 1000 entwarnung
    if [ "${VAL_AIR}" -gt "1300" ]; then
        if [ ! -e "$STATEFILE" ]; then
            /usr/bin/php $BOT/tele.php "bitte lueften luft schlecht! ${MESSAGE}"
            touch $STATEFILE
        fi
    fi

    if [ "${VAL_AIR}" -lt "1000" ]; then
        if [ -e "$STATEFILE" ]; then
            /usr/bin/php $BOT/tele.php "Luft erholt sich ;-) ${MESSAGE}"
            /bin/rm $STATEFILE
        fi
    fi

fi

STATEFILE=$TEMPDIR/dht_gpio7_temp.high

#temperatur 22-24
if [ "${VAL_TEMP}" -gt "24" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php $BOT/tele.php "Temp erreicht! ${MESSAGE}"
        touch $STATEFILE
    fi
fi

if [ "${VAL_TEMP}" -lt "22" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php $BOT/tele.php "Temp wieder OK ;-) ${MESSAGE}"
        /bin/rm $STATEFILE
    fi
fi

STATEFILE=$TEMPDIR/dht_gpio7_temp.low
#temperatur 22-24
if [ "${VAL_TEMP}" -lt "18" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php $BOT/tele.php "KALT - fenster offen? ${MESSAGE}"
        touch $STATEFILE
    fi
fi

if [ "${VAL_TEMP}" -gt "19" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php $BOT/tele.php "Temp wieder OK ;-) ${MESSAGE}"
        /bin/rm $STATEFILE
    fi
fi

STATEFILE=$TEMPDIR/dht_gpio7_hum.high

#humidy
if [ "${VAL_HUM}" -gt "55" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php $BOT/tele.php "Feuchte Klima OK ;-) ${MESSAGE}"
        touch $STATEFILE
    fi
fi

if [ "${VAL_HUM}" -lt "50" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php $BOT/tele.php "Feuchte gering! ${MESSAGE}"
        /bin/rm $STATEFILE
    fi
fi

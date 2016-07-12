#!/bin/bash
#Scriptname: am2302.sh
 
# based on: https://klenzel.de/1827
TEMPDIR=/opt/temp

/opt/airsensor/./airsensor -o -v >  $TEMPDIR/airsensor.txt

VALUE=`cat $TEMPDIR/airsensor.txt`
STATEFILE=$TEMPDIR/airsensor.high

# hysterese ab 1300, unter 1000 entwarnung
if [ "${VALUE}" -gt "1300" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "bitte lueften luft schlecht ${VALUE}"
        touch $STATEFILE
    fi
fi

if [ "${VALUE}" -lt "1000" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Luft erholt sich ;-) ${VALUE}"
        /bin/rm $STATEFILE
    fi
fi

VALUE=`cat $TEMPDIR/dht_gpio7_temp.txt`
VALUE=${VALUE/.*}
STATEFILE=$TEMPDIR/dht_gpio7_temp.high


#temperatur 22-24
if [ "${VALUE}" -gt "24" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Temp erreicht ${VALUE}"
        touch $STATEFILE
    fi
fi

if [ "${VALUE}" -lt "22" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Temp wieder OK ;-) ${VALUE}"
        /bin/rm $STATEFILE
    fi
fi

VALUE=`cat $TEMPDIR/dht_gpio7_hum.txt`
VALUE=${VALUE/.*}
STATEFILE=$TEMPDIR/dht_gpio7_hum.high


#humidy
if [ "${VALUE}" -gt "55" ]; then
    if [ ! -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Feuchte Klima OK ;-) ${VALUE}"
        touch $STATEFILE
    fi
fi

if [ "${VALUE}" -lt "50" ]; then
    if [ -e "$STATEFILE" ]; then
        /usr/bin/php /opt/temp/bot/tele.php "Feuchte gering ${VALUE}"
        /bin/rm $STATEFILE
    fi
fi

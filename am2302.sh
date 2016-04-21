#!/bin/bash
#Scriptname: am2302.sh
 
# based on: https://klenzel.de/1827
MINTEMP=-20
MAXTEMP=60
MINHUM=0
MAXHUM=100
 
TEMPDIR=/opt/temp
GPIO=7

INPUT=`/opt/am2302/lol_dht22/loldht $GPIO | /bin/grep "Temperature"`
HUM=$(echo $INPUT|cut -d " " -f3)
TEMP=$(echo $INPUT|cut -d " " -f7)
 
if [ $(echo "if (${HUM} > ${MAXHUM}) 1 else 0" | bc) -eq 1 -o $(echo "if (${HUM} < ${MINHUM}) 1 else 0" | bc) -eq 1 ]; then
    if [ -f $TEMPDIR/dht_gpio${GPIO}_hum.txt ]; then
        cat $TEMPDIR/dht_gpio${GPIO}_hum.txt
    fi
else
    echo $HUM
    echo $HUM > $TEMPDIR/dht_gpio${GPIO}_hum.txt
fi
 
if [ $(echo "if (${TEMP} > ${MAXTEMP}) 1 else 0" | bc) -eq 1 -o $(echo "if (${TEMP} < ${MINTEMP}) 1 else 0" | bc) -eq 1 ]; then
    if [ -f $TEMPDIR/dht_gpio${GPIO}_temp.txt ]; then
        cat $TEMPDIR/dht_gpio${GPIO}_temp.txt
    fi
else
    echo $TEMP
    echo $TEMP > $TEMPDIR/dht_gpio${GPIO}_temp.txt
fi

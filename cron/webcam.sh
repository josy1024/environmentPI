#!/bin/bash

### WEBCAM FOTO MACHEN
OUTPUT=/var/www/html/cam
# -v verbose?
# -r resolution

/usr/bin/fswebcam -r"1920x1080" $OUTPUT/latest.jpg 2> $OUTPUT/latest.txt


# CONFIG variablen für TELEGRAM BOT API:
. /opt/secure/telegram.sh
# enhaelt
#BOT_TOKEN=
#ROOM_ID=

### FOTO UPLOAD TO TELEGRAM API
/usr/bin/curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" -F chat_id="$ROOM_ID" -F photo="@$OUTPUT/latest.jpg"


###### ENTWICKLUNGSCODE....
#SnapFile=$OUTPUT/latest.jpg
#curl -s -X POST "https://api.telegram.org/bot--BOTID--/sendPhoto" -F chat_id="--CHATID--" -F photo="@$SnapFile"
#/usr/bin/php $BOT/attach.php $OUTPUT/latest.jpg

# problem in escape string! ;
#LOGTEXT=`cat $OUTPUT/latest.txt`
#/usr/bin/php $BOT/tele.php "$LOGTEXT"
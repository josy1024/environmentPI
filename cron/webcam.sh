#!/bin/bash

### WEBCAM FOTO MACHEN
OUTPUT=/var/www/html/cam
# -v verbose?
# -r resolution

# /etc/sudoers
#www-data ALL=NOPASSWD:/opt/433Utils/RPi_utils/send
#www-data ALL=NOPASSWD:/usr/bin/fswebcam

# skip 60 frames for sharping and auto color light adjust
sudo /usr/bin/fswebcam -S 60  -r"1920x1080" $OUTPUT/latest.jpg 2> $OUTPUT/latest.txt


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
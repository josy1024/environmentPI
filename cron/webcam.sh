#!/bin/bash
# webcam foto

OUTPUT=/var/www/html/cam
/usr/bin/fswebcam -v -r"1920x1080" $OUTPUT/latest.jpg 2> $OUTPUT/latest.txt

BOT=/opt/temp/bot
/usr/bin/php $BOT/attach.php $OUTPUT/latest.jpg

LOGTEXT = `cat $OUTPUT/latest.txt`
/usr/bin/php $BOT/tele.php "$LOGTEXT"
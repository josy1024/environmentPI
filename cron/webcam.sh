#!/bin/bash
# webcam foto

OUTPUT=/var/www/html/cam
/usr/bin/fswebcam -v -r"1920x1080" $OUTPUT/latest.jpg > $OUTPUT/latest.txt

BOT=/opt/temp/bot
/usr/bin/php $BOT/attach.php $OUTPUT/latest.jpg

/usr/bin/php $BOT/tele.php < $OUTPUT/latest.txt 
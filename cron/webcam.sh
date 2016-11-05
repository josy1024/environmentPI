#!/bin/bash
# webcam foto

OUTPUT=/var/www/html/cam
BOT=/opt/temp/bot

# -v verbose?
# -r resolution

/usr/bin/fswebcam -r"1920x1080" $OUTPUT/latest.jpg 2> $OUTPUT/latest.txt


/usr/bin/php $BOT/attach.php $OUTPUT/latest.jpg

# problem in escape string! ;
LOGTEXT=`cat $OUTPUT/latest.txt`
/usr/bin/php $BOT/tele.php "$LOGTEXT"
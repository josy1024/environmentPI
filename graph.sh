#!/bin/bash

cd /opt/temp

/usr/bin/rrdtool graph tempday.png \
-w 600 -h 400 \
-s 'now - 1 day' -e 'now' \
  DEF:temp0=temperature.rrd:temp0:AVERAGE \
  LINE2:temp0#00FF00:Innen


/usr/bin/rrdtool graph tempweek.png \
-w 600 -h 400 \
  -s 'now - 1 week' -e 'now' \
  DEF:temp0=temperature.rrd:temp0:AVERAGE \
  LINE2:temp0#00FF00:Innen

#/usr/bin/rrdtool graph tempmonth.png \
#  -s 'now - 4 week' -e 'now' \
#  DEF:temp0=temperature.rrd:temp0:AVERAGE \
#  LINE2:temp0#00FF00:Innen

rrdtool graph tempmonth.png \
-w 600 -h 400 \
  -s 'now - 1 month' -e 'now' \
  DEF:tempmins0=temperature.rrd:temp0:MIN \
  DEF:tempmaxs0=temperature.rrd:temp0:MAX \
  DEF:temp0=temperature.rrd:temp0:AVERAGE \
  CDEF:tempranges0=tempmaxs0,tempmins0,- \
  LINE1:tempmins0#0000FF \
  AREA:tempranges0#8dadf588::STACK \
  LINE1:tempmaxs0#0000FF \
  LINE2:temp0#0000FF:Innen

/usr/bin/rrdtool graph tempyear.png \
-w 600 -h 400 \
  -s 'now - 1 year' -e 'now' \
  DEF:tempmins0=temperature.rrd:temp0:MIN \
  DEF:tempmaxs0=temperature.rrd:temp0:MAX \
  DEF:temp0=temperature.rrd:temp0:AVERAGE \
  CDEF:tempranges0=tempmaxs0,tempmins0,- \
  LINE1:tempmins0#0000FF \
  AREA:tempranges0#8dadf588::STACK \
  LINE1:tempmaxs0#0000FF \
  LINE2:temp0#0000FF:Innen

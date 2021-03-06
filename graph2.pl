#!/usr/bin/perl
#
# CGI script to create image using RRD graph 
use CGI qw(:all);
use RRDs;
use strict;


# path to database
my $rrd='/opt/data/temperature.rrd';

# size
my $width=420;
my $height=320;

# read and check query params
my $query=new CGI;
my $type=$query->param('type');

$type='day' unless $type =~ /day|3 day|week|month|year/; 

if ($type eq "3 day") {
} else {
	$type="1 $type";
}

#my $width=$query->param('w');
#my $height=$query->param('h');

#$width=$query->param('w'); if $query->param('w') =~ /^[+-]?\d+$/;
#$height=$query->param('h'); if $query->param('h') =~ /^[+-]?\d+$/; 


# write image into temp file
my $tmpfile="/tmp/graph_$$.png";
#my $tmpfile="/opt/temp/graphs/graph_$type_$$.png";

my @opts=("-v", "°C",
"-w", $width,
"-h", $height,
"-s", "now - $type",
"-e", "now",
"--slope-mode",
"--font", "DEFAULT:7:",
"-D");

RRDs::graph($tmpfile,
  @opts,
#  "DEF:temp0=$rrd:temp0:AVERAGE",
#  "LINE2:temp0#00FF00:Innen",
"DEF:tempmins0=temperature.rrd:temp0:MIN",
"DEF:tempmaxs0=temperature.rrd:temp0:MAX",
"DEF:tempavg0=temperature.rrd:temp0:AVERAGE",
"DEF:temp0=temperature.rrd:temp0:AVERAGE",
"CDEF:tempranges0=tempmaxs0,tempmins0,-",
"LINE1:tempmins0#0000FF",
"AREA:tempranges0#8dadf588::STACK",
"LINE1:tempmaxs0#0000FF",
"LINE2:tempavg0#0000FF:Innen",
'GPRINT:temp0:LAST:"Jetzt\: %5.2lf"',
'GPRINT:tempavg0:AVERAGE:"Avg\: %5.2lf"\n',
'GPRINT:tempmaxs0:MAX:"Max\: %5.2lf"',
'GPRINT:tempmins0:MIN:"Min\: %5.2lf"\n',
);

# check error
my $err=RRDs::error;
die "$err\n" if $err;

# feed tmpfile to stdout
open(IMG, $tmpfile) or die "can't open $tmpfile\n";
print header(-type=>'image/png', -expires=>'+1m');
print <IMG>;
close IMG;
#unlink $tmpfile;


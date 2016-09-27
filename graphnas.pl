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

$type='day' unless $type =~ /day|week|month|year/; 


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
"-s", "now - 1 $type",
"-e", "now",
"-D");

RRDs::graph($tmpfile,
  @opts,
"DEF:tempmins1=nas.rrd:disk1:MIN",
"DEF:tempmaxs1=nas.rrd:disk1:MAX",
"DEF:disk1=nas.rrd:disk1:AVERAGE",
"CDEF:tempranges1=tempmaxs1,tempmins1,-",
"LINE1:tempmins1#0000FF",
"AREA:tempranges1#8dadf588::STACK",
"LINE1:tempmaxs1#0000FF",
"LINE2:disk1#0000FFA0:disk1",
"DEF:tempmins2=nas.rrd:disk2:MIN",
"DEF:tempmaxs2=nas.rrd:disk2:MAX",
"DEF:disk2=nas.rrd:disk2:AVERAGE",
"CDEF:tempranges2=tempmaxs2,tempmins2,-",
"LINE3:tempmins2#00FFFF",
"AREA:tempranges2#008ff588::STACK",
"LINE3:tempmaxs2#00FFFF",
"LINE4:disk2#00FFFFA0:disk2",
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


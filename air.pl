#!/usr/bin/perl
#
# CGI script to create image using RRD graph#

# example: http://localhost/air.pl?type=day&h=800&w=1200&offt=1


use CGI qw(:all);
use RRDs;
use strict;


# path to database
my $rrd='/opt/temp/airsensor.rrd';

my $query=new CGI;

# size
my $width=420;
my $height=320;

# read and check query params
my $query=new CGI;
my $type=$query->param('type');

#$width=$query->param('w');
$width=$query->param('w') unless $query->param('w') < 100;
$height=$query->param('h') unless $query->param('h') < 100;

#$rrd=$query->param('rrd') unless $query->param('rrd') == 'airsensor.rrd';

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
"--x-grid", "MINUTE:60:HOUR:3:HOUR:6:0:%X",
#"--y-grid", "1:1",

"--right-axis-label", "Feuchte",
"--right-axis", "2:0",
"--right-axis-format", "%1.1lf",

#"--logarithmic",
"-A",
"-D");

my @otemp=(
"DEF:tempmins0=airsensor.rrd:temp:MIN",
"DEF:tempmaxs0=airsensor.rrd:temp:MAX",
"DEF:tempavg0=airsensor.rrd:temp:AVERAGE",
#"DEF:lastwtempavg0=airsensor.rrd:temp:AVERAGE:start=end-1w:end=now-1w",
#"DEF:lastdtempavg0=airsensor.rrd:temp:AVERAGE:start=end-1w:end=now-1d",
#"SHIFT:lastwtempavg0:604800",
#"SHIFT:lastdtempavg0:86400",
"DEF:temp=airsensor.rrd:temp:AVERAGE",
"CDEF:tempranges0=tempmaxs0,tempmins0,-",
"LINE1:tempmins0#F08080",
"AREA:tempranges0#F0808030::STACK",
"LINE1:tempmaxs0#F08080",
"LINE2:tempavg0#FF3333:Temp aktuell",
'GPRINT:temp:LAST:"Jetzt T\: %5.2lf"',
'GPRINT:tempmaxs0:MAX:"Max\: %5.2lf"',
'GPRINT:tempmins0:MIN:"Min\: %5.2lf"\n',
'GPRINT:tempavg0:AVERAGE:"T Avg\: %5.2lf"\n',
);


my @ohum=(
"DEF:hum=airsensor.rrd:hum:AVERAGE",
"DEF:raw_hummins0=airsensor.rrd:hum:MIN",
"DEF:raw_hummaxs0=airsensor.rrd:hum:MAX",
"DEF:raw_humavg0=airsensor.rrd:hum:AVERAGE",

"CDEF:scaled_hum=hum,0.5,*",
"CDEF:hummins0=raw_hummins0,0.5,*",
"CDEF:hummaxs0=raw_hummaxs0,0.5,*",
"CDEF:humavg0=raw_humavg0,0.5,*",
"CDEF:humranges0=hummaxs0,hummins0,-",

"LINE1:hummins0#a0a0FF",
"AREA:humranges0#a0a0f530::STACK",
"LINE1:hummaxs0#a0a0FF",
"LINE2:scaled_hum#0000FF:Feuchte aktuell",
'GPRINT:hum:LAST:"Jetzt H\: %5.2lf"',
'GPRINT:humavg0:AVERAGE:"H Avg\: %5.2lf"\n',

);

my @oair=(
"DEF:airmins0=airsensor.rrd:air:MIN",
"DEF:airmaxs0=airsensor.rrd:air:MAX",
"DEF:airavg0=airsensor.rrd:air:AVERAGE",
"DEF:air=airsensor.rrd:air:AVERAGE",
"LINE2:airavg0#FF8333:air aktuell",
'GPRINT:air:LAST:"Jetzt A\: %5.2lf"',
'GPRINT:airavg0:AVERAGE:"A Avg\: %5.2lf"\n',
);

#my @leer=(" ",);

unless ($query->param('offt') < 1)
{
  undef @otemp;
}

unless ($query->param('offa') < 1)
{
  undef @oair;
}

unless ($query->param('offh') < 1)
{
  undef @ohum;
}


RRDs::graph($tmpfile,
  @opts,
  @otemp,
  @ohum,
  @oair,

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


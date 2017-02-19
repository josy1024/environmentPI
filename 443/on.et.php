<?php

$start = microtime(true);

#if (isset($_GET["on"])) {$on=$_GET["on"];}

$on = 1;
#$schalter = 2;
#$installid="11111";

$PIDFILE = "onstats.et.pid";

$looper = 0;

if (isset($_GET["on"])) {$on = intval($_GET["on"]);}

#if (isset($_GET["s"])) {$schalter= intval($_GET["s"]);}

## 433 send + receive
# GPIO0 17 433 receive	(sniffer)
# GPIO4	23 433 send (send)

# GPIO PIN 4:

$prg="sudo /var/www/rfoutlet/RFSource/codesend -p 4 $on";

echo $prg;

usleep (rand(0, 20000));
$runme = "";
do {
#    exec("ps aux | grep 433 | grep -i 'send'", $pids); 
#    exec("ps aux | grep -v 'ps aux' | grep -i 'send'", $pids);
    unset ($pids);
    exec("/usr/bin/pgrep 'codesend' ", $pids);
    $runme = file_get_contents($PIDFILE, true);

    var_dump($pids);

    if (   (empty($pids)) && ($runme != "WAIT")) {
    # läuft nicht - weiter ;-)
        break;
    } else {
            # randomize queue
            usleep (rand(100000, 100000));
            $looper++;
    }

} while ($looper < 3);

file_put_contents($PIDFILE, "WAIT");

$last_line = system($prg, $retval);


echo '
</pre>
<hr />Letzte Zeile der Ausgabe: ' . $last_line . '
<hr />Rückgabewert: ' . $retval .' Anlauf: ' . $looper;

file_put_contents($PIDFILE, "");

$time_elapsed_secs = microtime(true) - $start;

echo '<hr />Time: ' . $time_elapsed_secs;

?>
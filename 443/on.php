<?php


#if (isset($_GET["on"])) {$on=$_GET["on"];}


$on = 1;
$schalter = 2;
$installid="11111";

$looper = 0;

if (isset($_GET["on"])) {$on = intval($_GET["on"]);}

if (isset($_GET["s"])) {$schalter= intval($_GET["s"]);}

$prg="sudo /opt/433Utils/RPi_utils/send $installid $schalter $on";

echo $prg;

usleep (rand(0, 20000));

do {
    exec("ps aux | grep 433 | grep -i 'send'", $pids);


    if(empty($pids)) {
    # läuft nicht - weiter ;-)
        break;
    } else {
            # randomize queue
            usleep (rand(50000, 100000));
            $looper++;
    }

} while ($looper < 40);

$last_line = system($prg, $retval);

echo '
</pre>
<hr />Letzte Zeile der Ausgabe: ' . $last_line . '
<hr />Rückgabewert: ' . $retval .'
<hr />Anlauf: ' . $looper;

?>
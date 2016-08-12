<?php


#if (isset($_GET["on"])) {$on=$_GET["on"];}


$on = 1;
$schalter = 2;
$installid="11111";

if (isset($_GET["on"])) {$on = intval($_GET["on"]);}

if (isset($_GET["s"])) {$schalter= intval($_GET["s"]);}

$prg="sudo /opt/433Utils/RPi_utils/send $installid $schalter $on";

echo $prg;

$last_line = system($prg, $retval);

echo '
</pre>
<hr />Letzte Zeile der Ausgabe: ' . $last_line . '
<hr />Rückgabewert: ' . $retval;

?>
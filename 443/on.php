<?php


#if (isset($_GET["on"])) {$on=$_GET["on"];}

$schalter = 2;
$on = 1;
$installid="11111";

if (isset($_GET["on"])) {$on=$_GET["on"];}

$prg="sudo /opt/433Utils/RPi_utils/send $installid $schalter $on";

echo $prg;

$last_line = system($prg, $retval);

echo '
</pre>
<hr />Letzte Zeile der Ausgabe: ' . $last_line . '
<hr />Rückgabewert: ' . $retval;

?>

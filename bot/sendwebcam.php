<?php

$prg="sudo /opt/temp/cron/webcam.sh";

echo $prg;
$last_line = system($prg, $retval);

echo '
</pre>
<hr />Letzte Zeile der Ausgabe: ' . $last_line . '
<hr />Rückgabewert: ' . $retval;

?>
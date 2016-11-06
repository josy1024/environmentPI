<?php

# no sudo needed... 

$prg="/opt/temp/cron/webcam.sh";

echo $prg;
echo '<pre>';
$last_line = system($prg, $retval);

# <hr />Letzte Zeile der Ausgabe: ' . $last_line . '
echo '
<hr />Rückgabewert: ' . $retval;

?>
<?php
$h=600;
$w=800;
?>
<html>
<header>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="basicresponsive.css">
</header>
<body>
<h1>temp oscm rasperry pi</h1>
<p>
<form action="graph3.pl" method="get" target="graph2">
<div>
  <fieldset class="w-input field">
  <legend>Zeitraum</legend>
  <input type="radio" name="type" value="day" />Tag
  <input type="radio" name="type" value="3 day" checked="checked"/>3 Tage
  <input type="radio" name="type" value="week" checked="checked"/>Woche
  <input type="radio" name="type" value="month"/>Monat
  <input type="radio" name="type" value="year"/>Jahr
  </fieldset>
  <input type="submit" value="Anzeigen" class="w-button button"/>
</div>
  <input type="hidden" name="h" value="<?php echo $h ?>"/>
  <input type="hidden" name="w" value="<?php echo $w ?>"/>
  </form><iframe marginwidth="0" marginheight="0" frameborder="0" width="<?php echo $w; ?>" height="<?php echo $h; ?>" name="graph2"
  src="graph3.pl?type=week&w=<?php echo $w; ?>&h=<?php echo $h; ?>">
</iframe>
</p>
<form action="443/on.php" method="get" target="onoff">
<input type="hidden" name="s" id="s" value="1">
<button name="on" type="submit" value="1" class="w-button button"/> ON</button>
<button name="on" type="submit" value="0" class="w-button button"/> OFF </button>
</form>
<form action="443/on.php" method="get" target="onoff">
<input type="hidden" name="s" id="s" value="2">
<button name="on" type="submit" value="1" class="w-button button"/> ON</button>
<button name="on" type="submit" value="0" class="w-button button"/> OFF </button>
</form>
<iframe width="0" height="0" name="onoff" src=""></iframe>
</body>
</html>

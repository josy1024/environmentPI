<?php
$h=400;
$w=600;
?>
<html>
<header>
<link rel="stylesheet" href="basicresponsive.css">
<meta>
</header>
<body>
<h1>temp oscm rasperry pi</h1>
<p>
<form action="graph.pl" method="get" target="graph">
  <fieldset class="w-input field">
  <legend>Zeitraum</legend>
  <input type="radio" name="type" value="day"/>Tag
  <input type="radio" name="type" value="3 day" checked="checked"/>3 Tage
  <input type="radio" name="type" value="week"/>Woche
  <input type="radio" name="type" value="month"/>Monat
  <input type="radio" name="type" value="year"/>Jahr
  </fieldset>
  <input type="submit" value="Anzeigen" class="w-button button" />
</form>
<iframe marginwidth="0" marginheight="0" frameborder="0" width="420" height="320" name="graph"
src="graph.pl?type=3+day">
</iframe> 
</p>
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
</body>
</html>

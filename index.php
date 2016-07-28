<?php
$h=600;
$w=800;
?>
<html>
<header>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="static/basicresponsive.css">
<link href="static/flex-layout-attribute.min.css" rel="stylesheet">
<script src="static/jquery.min.js"></script>
<script src="static/jquery.simpleWeather.min.js"></script>
 <title>smart home</title>
</header>
<body>
<h1>smart home</h1>
<h2>graphs</h2>
<div layout="row center-stretch">
    <div><a href="http://10.0.0.15/am2302.pl?type=day&h=800&w=1200" target="am2302">AM2302</a></div>
    <div><a href="http://10.0.0.15/graph3.pl?type=day&h=800&w=1200" target="temp1802">Temp1802</a></div>
    <div><a href="http://10.0.0.15/air.pl?type=day&h=800&w=1200" target="air">air</a></div>
</div> 
</p>
<div id="weather"></div>
<div class="w-container abstand">
<form action="443/on.php" method="get" target="onoff">
<input type="hidden" name="s" id="s" value="1">
<button name="on" type="submit" value="1" class="w-button button"/>Lampe WZ ON</button>
<button name="on" type="submit" value="0" class="w-button button"/> OFF </button>
</form></div>
<div class="w-container abstand">
<form action="443/on.php" method="get" target="onoff">
<input type="hidden" name="s" id="s" value="3">
<button name="on" type="submit" value="1" class="w-button button"/>BlueRay WZ ON</button>
<button name="on" type="submit" value="0" class="w-button button"/> OFF </button>
</form>
</div>
<div class="w-container abstand">
<form action="443/on.php" method="get" target="onoff">
<input type="hidden" name="s" id="s" value="2">
<button name="on" type="submit" value="1" class="w-button button"/>Schalter Büro ON</button>
<button name="on" type="submit" value="0" class="w-button button"/> OFF </button>
</form>
</div>
<iframe width="0" height="0" name="onoff" src=""></iframe>
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

<form action="air.pl" method="get" target="air">
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
  </form><iframe marginwidth="0" marginheight="0" frameborder="0" width="<?php echo $w; ?>" height="<?php echo $h; ?>" name="air"
  src="air.pl?type=week&w=<?php echo $w; ?>&h=<?php echo $h; ?>">
</iframe>
</p>

<script>
//Docs at http://simpleweatherjs.com
$(document).ready(function() {
  $.simpleWeather({
    location: 'Fahnsdorf, AT',
    woeid: '',
    unit: 'c',
    success: function(weather) {
      html = '<h2><i class="icon-'+weather.code+'"></i> '+weather.temp+'&deg;'+weather.units.temp+'</h2>';
      html += '<ul><li>'+weather.city+', '+weather.region+'</li>';
      html += '<li class="currently">'+weather.currently+'</li>';
      html += '<li>'+weather.wind.direction+' '+weather.wind.speed+' '+weather.units.speed+'</li>';
      html += '<li>'+weather.sunrise+' - '+weather.sunset+'</li>';
      html +='</ul>';
  
      $("#weather").html(html);
    },
    error: function(error) {
      $("#weather").html('<p>'+error+'</p>');
    }
  });
});
</script>

</body>
</html>

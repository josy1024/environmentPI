<?php

# QUELLE: http://stackoverflow.com/questions/32296272/telegram-bot-api-how-to-send-a-photo-using-php

# $argument1
#include "config.php";


# bot token file
include "/opt/secure/telegram.php";

$photo = $argv[1];
# apiRequest("sendMessage", array('chat_id' => ROOM_ID , "text" => $argument1));

$chat_id = ROOM_ID;
$bot_url    = "https://api.telegram.org/bot" & BOT_TOKEN & "/";
$url        = $bot_url . "sendPhoto?chat_id=" . $chat_id ;

echo $photo;

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    "Content-Type:multipart/form-data"
));
curl_setopt($ch, CURLOPT_URL, $url); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
curl_setopt($ch, CURLOPT_POSTFIELDS, array(
    "photo"     => "@$photo", 
)); 
curl_setopt($ch, CURLOPT_INFILESIZE, filesize( $photo ));
$output = curl_exec($ch);
print $output;


?>
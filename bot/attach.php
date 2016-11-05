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

    $caption = $photo;
    // following ones are optional, so could be set as null
    $reply_to_message_id = null;
    $reply_markup = null;

    $data = array(
        'chat_id' => urlencode($chat_id),
         // make sure you do NOT forget @ sign
        'photo' => '@'.$photo,
        'caption' => urlencode($caption),
        'reply_to_message_id' => urlencode($reply_to_message_id),
        'reply_markup' => urlencode($reply_markup)
    );

    //  open connection
    $ch = curl_init();
    //  set the url
    curl_setopt($ch, CURLOPT_URL, $url);
    //  number of POST vars
    curl_setopt($ch, CURLOPT_POST, count($fields));
    //  POST data
    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
    //  To display result of curl
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    //  execute post
    $result = curl_exec($ch);
    //  close connection
    curl_close($ch);
    
    echo $result;
?>
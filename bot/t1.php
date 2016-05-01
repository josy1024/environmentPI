<?php

include "config.php";

#define('BOT_TOKEN', '12345678:replace-me-with-real-token');
define('API_URL', 'https://api.telegram.org/bot'.BOT_TOKEN.'/');

function sendMessage($chatID, $messaggio) {
    echo "sending message to " . $chatID . "\n";


    $url = API_URL . "/sendMessage?chat_id=" . $chatID;
    $url = $url . "&text=" . urlencode($messaggio);
    $ch = curl_init();
    $optArray = array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true
    );
    curl_setopt_array($ch, $optArray);
    $http_code = curl_exec($ch);
    curl_close($ch);
    
      if ($http_code >= 500) {
            // do not wat to DDOS server if something goes wrong
            sleep(10);
            return false;
        } else if ($http_code != 200) {
            $response = json_decode($response, true);
            error_log("Request has failed with error {$response['error_code']}: {$response['description']}\n");
            if ($http_code == 401) {
            throw new Exception('Invalid access token provided');
            }
            return false;
        } else {
            $response = json_decode($response, true);
            if (isset($response['description'])) {
            error_log("Request was successfull: {$response['description']}\n");
            }
            $response = $response['result'];
        }
}

#$token = "bot<insertTokenHere>";
$chatid = "@Josy1024";
sendMessage($chatid,"Hello World" );

?>
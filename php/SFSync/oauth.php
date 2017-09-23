<?php

function getSFCredentials(){

        $return = false;

        $CLIENT_ID = SF_CLIENT_ID;
        $CLIENT_SECRET = SF_CLIENT_SECRET;
        $LOGIN_URI = SF_LOGIN_URI;
        $USERNAME = SF_USERNAME;
        $PASSWORD = SF_PASSWORD;
        $REDIRECT_URI = SF_REDIRECT_URI;
        
        // Salesforce service address
        $token_url = SF_TOKEN_URI;
        
        // Payload for getting access token via Oauth password flow - http://help.salesforce.com/help/doc/en/remoteaccess_oauth_username_password_flow.htm
        $auth_url = "grant_type=password&format=json&response_type=code"
                . "&client_id=" . $CLIENT_ID 
                . "&client_secret=" . $CLIENT_SECRET
                . "&redirect_uri=" . urlencode($REDIRECT_URI)
                . "&username=" . $USERNAME
                . "&password=" . $PASSWORD;
                
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL,$token_url);
        //curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded'));
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_CAINFO, getcwd() . '\cacert.pem'); 
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $auth_url);
        
        $json_response = curl_exec($curl);
        
        $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        
        if( $status == 200 ) {
            // Decode the response and check for access token and instance URL - Kill if not present
            $return = json_decode($json_response, true);
        } else {
            //die("Authentication error.");
            die("Error: call to token URL $token_url failed with status $status, response $json_response, curl_error " . curl_error($curl) . ", curl_errno " . curl_errno($curl));
        }

        curl_close($curl);
        
        // Kill the process if unsuccessful and log the curl error
        
        return $return;
}
?>
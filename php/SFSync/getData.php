<?php
//$configFile = htmlspecialchars($_GET["config"]);
require_once 'config.php';
require_once 'DbToJson.php';
require_once 'oauth.php';
$finalSQLTablesWithFrequencyAndJSON = getTables();
print_r($finalSQLTablesWithFrequencyAndJSON);
$finalTables = $finalSQLTablesWithFrequencyAndJSON['finalTables'];
foreach ($finalTables as $identifier => $tables) {

//$tables = unserialize(TABLES);
    foreach($tables as $key => $value){
        $finalArray = getArray($key,$value,$identifier,$finalSQLTablesWithFrequencyAndJSON);
        //ehco  'For table'.$key;
        foreach ($finalArray as $rowsKey => $rowsValue) {
            $arr = array();
            //echo json_encode($rowsValue['uniqueFieldName']);
            echo 'For chunck '.$rowsKey;
            
            $reqString = json_encode( $rowsValue);
            //echo $reqString;
            //echo $reqString;
            $sfCredentials = getSFCredentials();
            $token	= $sfCredentials['access_token'];
            $instance_url=$sfCredentials['instance_url'];
            $headers= array("Accept: application/json","Content-Type: application/json","Authorization: OAuth $token"); 
            $url;
            //echo $key;
            if($key == 'PRSPRCSCH'){
                $url = "$instance_url/services/apexrest/SBQQDiscountScheduleService";
            }else{
                $url = "$instance_url/services/apexrest/insertAndUpdateProduct";
            }
           // echo $url;
            
            //echo $url;
            //$reqObj Is Used To Request Call's Url To Migrate
            $reqcurl = curl_init($url);

            //echo 'Request String ---> '.$reqString;
            curl_setopt($reqcurl, CURLOPT_HEADER,false);
            curl_setopt($reqcurl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($reqcurl, CURLOPT_CAINFO, getcwd() . '\cacert.pem'); 
            curl_setopt($reqcurl, CURLOPT_HTTPHEADER,$headers);
            curl_setopt($reqcurl,CURLOPT_POST,true);
            curl_setopt($reqcurl,CURLOPT_POSTFIELDS,$reqString);
            $reqResponse = curl_exec($reqcurl);
            curl_close($reqcurl);
            echo '<br>';
            //echo $reqcurl;
            echo 'JSON Response -- > '.$reqResponse;
            date_default_timezone_set('America/New_York');
            writeLog("####".date('d-m-Y H:i:s')." : {$key},{$identifier},{".$reqResponse."}");
        }
    }

}
if ($handle = fopen(TIMESTAMP, 'w')) {
    $newJSON = $finalSQLTablesWithFrequencyAndJSON['newJSON'];
    $oldJSON = $finalSQLTablesWithFrequencyAndJSON['oldJSON'];
    foreach ($finalTables as $identifier => $tables) {
         if(array_key_exists($identifier, $newJSON)){
            $oldJSON[$identifier] = $newJSON[$identifier];
        }
    }
   /* foreach ($oldJSON as $frequency => $timestamp) {
        # code...
        if(array_key_exists($frequency, $newJSON)){
            $oldJSON[$frequency] = $newJSON[$frequency];
        }
    }*/
    $success = fwrite($handle, json_encode( $oldJSON));

    fclose($handle);
}
?>
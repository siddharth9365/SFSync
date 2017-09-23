<?php
require_once $configFile;
function getData($sql,$tableName,$exIdFieldName){
    $servername = SERVERNAME;
    $username = DB_USERNAME;
    $password = DB_PASSWORD;
    $dbname = DB_NAME;
   //mysql_connect($servername, $username, $password) or die("Connection Failed");
    //mysql_select_db($dbname)or die("Connection Failed");
    $connectionInfo = array("UID"=>$username, "PWD"=>$password);
    $conn = sqlsrv_connect( $servername, $connectionInfo); 
    ini_set('memory_limit', '256M');
    if( $conn === false ) {
        echo "connection fail ";
        die( print_r( sqlsrv_errors(), true));
    }else{
        echo "connection success ";
    }
    
    $ini_array = parse_ini_file(TIMESTAMP);

    $lastDate; 
    $lastTime;
    if(sizeof($ini_array)>0){
        $lastDate = $ini_array["date"];
        $lastTime = $ini_array["time"]; 
    }
    //echo $lastDate;
    $currentDate = new DateTime();
    $currentTime = new DateTime();
    if(isset($lastDate) && isset($lastTime)){
        $sql = $sql." WHERE PGRMNDT >".$lastDate." AND PGRMNDT <".$currentDate->format("Ymd")." AND PGRMNTM >".$lastTime." AND PGRMNTM <".$currentTime->format("His");
    }
    $stringArray = "date = ".$currentDate->format("Ymd")."\ntime = ".$currentTime->format("His");

    echo $sql;
    //$ini_array['timestamp'] 
    $result = sqlsrv_query($conn,$sql);
    if ($handle = fopen(TIMESTAMP, 'w')) { 
        $success = fwrite($handle, $stringArray);
        fclose($handle);
    }

    //$tableData= array('tableData');

    if( $result === false) {
        die( print_r( sqlsrv_errors(), true) );
    }
    $count = sqlsrv_num_rows($result);
    echo "Total Record Found for ".$tableName."is ".$count;
    $fnalArray = array();
    // output data of each row
    //counter
    $counter = 0;
    $rows = array();
    while ($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC)) {
        //$tempCount = $tempCount>200?1:$tempCount=null?1:$tempCount;
        //while ($tempCount <= 200) {
            # code...
        $counter++;
        $colums =array();
        foreach($row as $key => $value) {
        // print "$key = $value <br />";
            $data = array('fieldName' => trim($key),'fieldValue' => trim($value));
            array_push($colums,$data);
            //$data = array();
            //echo 'fieldname =>'.$key.' | fieldvalue =>'.$value;
            
        }
        array_push($rows,$colums);
        
    //}
        if($counter>200){
            $arr = array('tableName' => $tableName,'uniqueFieldName' => $exIdFieldName,'tableData' => $rows);
            array_push($fnalArray, $arr);
            $rows = array();
            $counter = 0;
        }
    }
    echo "\n".$counter;
    if($counter>0){
        $arr=array('tableName' => $tableName,'uniqueFieldName' => $exIdFieldName,'tableData' => $rows);
        array_push($fnalArray, $arr);
    }
   
    return $fnalArray;
}

function getArray($key,$value){
    //$tables = unserialize(TABLES);
    $arrData=array();
    $query = 'SELECT * FROM PRSPROD.S100030E.SLSFORCE.'.$key;
    //array_push($arrData,getData($query,$key,$value));
    //foreach ($arrData as $key => $value) {
    //    echo "<br/>";
      //  echo "Final Array Key ".$key;
        //# code...
    //}
    return getData($query,$key,$value);
}

function getTables(){
    $jsonArray = array();
    $finalTablesArray = array();
    $tables = unserialize(TABLES);
    $datetime = new DateTime();
    $currentDateTime = $datetime -> format("Y-m-d H:i:s");
    $tablesTimeArray = json_decode(file_get_contents(TIMESTAMP),true);
    //if ($handle = fopen(TIMESTAMP, 'w')) { 
        //echo 'file : '.file_get_contents(TIMESTAMP);
        
        if(isset($tablesTimeArray)){
            foreach ($tables as $tableFrequency => $tablesArray) {
                //echo 'd'.isset($tablesTimeArray[$tableFrequency]);
                if(isset($tablesTimeArray[$tableFrequency])){
                    $jsonDateTime = $tablesTimeArray[$tableFrequency];
                    $tempJsonDateTime = strtotime($jsonDateTime);
                    $tempcurrentDateTime = strtotime($currentDateTime);
                    $diff = abs($tempcurrentDateTime - $tempJsonDateTime);
        
                    $minutes = $diff/60;
                    echo $minutes;
                    //echo ($currentDateTime - $jsonDateTime)/60);
                    if($minutes >= $tableFrequency){
                        $jsonArray[$tableFrequency] = $currentDateTime;
                        array_push($finalTablesArray, $tablesArray);
                    }else{
                        $jsonArray[$tableFrequency] = $jsonDateTime;
                    }
                }else{
                    array_push($finalTablesArray, $tablesArray);
                    $jsonArray[$tableFrequency] = $currentDateTime;
                }
            }
            //$success = fwrite($handle, json_encode($jsonArray));
        }else{
             foreach ($tables as $tableFrequency => $tablesArray) {
                
                array_push($finalTablesArray, $tablesArray);
                $jsonArray[$tableFrequency] = $currentDateTime;
             }
            //$success = fwrite($handle, json_encode($jsonArray));
        }
        fclose($handle);
    //}
}
?>

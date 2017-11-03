<?php
define('SF_CLIENT_ID', '3MVG9szVa2RxsqBZ2jwi_C.ZHCetIvU0ZJm.xKBqmghD.Uv.FP4mWfSWYC331ny7FnMWzo5dZD.tnDZdNkXPb');
define('SF_CLIENT_SECRET', '7150359005666097193');
define('SF_LOGIN_URI', 'https://login.salesforce.com');
define('SF_USERNAME', 'gkulkarni@pkcontract.com');
define('SF_PASSWORD', 'oreo6789G65naBpAOZSCqFufXn6ZtIsav');
define('SF_TOKEN_URI', 'https://login.salesforce.com/services/oauth2/token');
define('SF_REDIRECT_URI', 'https://localhost/Geeta/oauth_callback.php');

define('DB_USERNAME','');
define('DB_PASSWORD','');
define('DB_NAME','S100030E');
define('SERVERNAME','PKV-WEB6');
//define('TABLES',serialize (array ('PRSPATFL' => 'PPTPATID','PRSCLRFL' => 'PCLSKUID','PRSCERTFL' => 'PCEDIV','PRSGRGFL' => 'PGRDIV')));
define('TABLES',serialize (array(60 => array ('PRSPATFL' => 'PPTPATID','PRSCLRFL' => 'PCLSKUID','PRSPRCSCH' => 'PRCSCHCD','PRSGRGFL' => 'PGRFAB'),720 => array('PRSFINFL' => 'PFNCODE','PRSCERTFL' => 'PCETSCD','PRSCUSTFL' => 'PCSCUST','PRSSLSFL' => 'PSLSLS#','PRSHOTEL' => 'PHTCODE','PRSBRAND' => 'PBRBRN#','PRSBRPGM' => 'PBPBRP#'))));
define('TIMESTAMP',"config_timestamp.txt");
?>



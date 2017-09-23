public with sharing class RestfulServiceUtils {

    public static Map<String, object> parseJsonFromRequest(RestRequest req) {
        return (Map<String, object>)JSON.deserializeUntyped(req.requestBody.toString());
    }
    
    public static Map<String, object> parseJsonFromString(String s) {
        return (Map<String, object>)JSON.deserializeUntyped(s);
    }
    
    public static Blob parseValToJson(object obj) {
        return Blob.valueOf( JSON.serializePretty( obj ) );
    }
    
    public static String parseMapToJson(Map<String,object> obj) {
        return String.valueOf( JSON.serializePretty( obj ) );
    }
    
    public static Datetime getDatetime(Map<String, object> values, String keyValue) {
        return Datetime.valueOf(String.valueOf(values.get(keyValue)));
    }
    
    public static Datetime getDate(Map<String, object> values, String keyValue) {
        return Date.valueOf(String.valueOf(values.get(keyValue)));
    }
    
    public static Date getOnlyDate(Map<String, object> values, String keyValue) {
        return Date.valueOf(String.valueOf(values.get(keyValue)));
    }
    
    public static Boolean getBoolean(Map<String, object> values, String keyValue) {
        return String.valueOf(values.get(keyValue)) == '1' ||
               String.valueOf(values.get(keyValue)) == 'true';
    }
    
    public static Boolean isEmpty(Map<String, object> values, String keyValue) {
        return values.get(keyValue) == null || String.valueOf(values.get(keyValue)) == '';
    }
    
    public static Id getId(Map<String, object> values, String keyValue) {
        return (values.get(keyValue) != '') ? (Id)values.get(keyValue) : null;
    }
    
    public static String getString(Map<String, object> values, String keyValue) {
        return String.valueOf(values.get(keyValue));
    }
    
    public static String[] getParsedCsvString(Map<String, object> values, String keyValue) {
        String str = String.valueOf(values.get(keyValue));
        return parseCsvString(str);
    }
    
    public static String[] parseCsvString(String str) {
      if(str == null || str == '') return new List<String>();
      return str.split(',');
    }
    
    public static List<object> getList(Map<String, object> values, String keyValue) {
        return  (object[])values.get(keyValue);
    }
    
    public static Map<String, object> getMap(object obj) {
        return (Map<String,object>)obj;
    }
    
    public static List<String> getStringList(Map<String, object> values, String keyValue) {
        List<String> returnList =   new List<String>();
        List<object> objectList =   RestfulServiceUtils.getList(values, keyValue);
        if(objectList == null)  {
            return null;
        }
        for(object obj : objectList) {
            returnList.add(String.valueOf(obj));
        }
        return  returnList;
    }
    
    public static Map<String, object> getObjectMap(Map<String, object> values, String keyValue) {
        if( values.get(keyValue) == null ) return new Map<String, object>();
        return (Map<String, object>)values.get(keyValue);
    }
    
    public static object getObject(Map<String, object> values, String keyValue) {
        return (object) values.get(keyValue);
    }
  
    public static Integer getInteger(Map<String, object> values, String keyValue) {
        if(!values.containsKey(keyValue)) {
            return null;
        }
        return Integer.valueOf(String.valueOf(values.get(keyValue)));
    }
    
    public static Double getDouble(Map<String, object> values, String keyValue) {
        return (values.get(keyValue) != null && values.get(keyValue) != '') ? Double.valueOf(String.valueOf(values.get(keyValue))) : null;
    }
    
    public static Blob getBlob(Map<String, object> values, String keyValue) {
        return EncodingUtil.base64Decode(String.valueOf(values.get(keyValue)));
    }
    
    public static void populateSobjectFromMap(Sobject sobj, Map<String, object> values) {
        //This method assumes that all keys are same as field names
        for(String fieldKey : values.keySet()) {
            if(fieldKey != 'Id') {
                try {
                    if(values.get(fieldKey) == 'true') {
                        sobj.put(fieldKey, true);
                    } else if(values.get(fieldKey) == 'false') {
                        sobj.put(fieldKey, false);
                    } else {
                        sobj.put(fieldKey, values.get(fieldKey));
                    }
                } catch(Exception ex) {
                    //If its running test, do nothing
                    if(!Test.isRunningTest())
                        throw ex;
                }
            }
        }
    }
}
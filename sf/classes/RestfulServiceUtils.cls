public with sharing class RestfulServiceUtils {

    public static Map<String, object> parseJsonFromRequest(RestRequest req) {
        return (Map<String, object>)JSON.deserializeUntyped(req.requestBody.toString());
    }
    
    public static Blob parseValToJson(object obj) {
        return Blob.valueOf( JSON.serializePretty( obj ) );
    }
}
@isTest
public class SBQQDiscountScheduleServiceTest {
    static String uri = '/services/apexrest/SBQQDiscountScheduleService';
    static String method = 'POST';
	public static testMethod void method2(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PRCSCHCD';
        dyTbleMap.Db_Table_Name__c = 'PRSPRCSCH';
        dyTbleMap.Sf_Field_Name__c = 'PRSPRCSCH__c';
        dyTbleMap.Sf_Table_Name__c = 'SBQQ__DiscountSchedule__c';
        insert dyTbleMap;
        
        SBQQ__DiscountSchedule__c discountSchedule = new SBQQ__DiscountSchedule__c();
        discountSchedule.Name = 'A101';
        insert discountSchedule;
        String json ='{"tableName": "PRSPRCSCH","uniqueFieldName": "PRCSCHCD","tableData": [[{"fieldName": "PRCSCHCD","fieldValue": "A101"},{"fieldName":"PRCDSCB","fieldValue":"11.56069"},{"fieldName":"PRCDSCC","fieldValue":"19.26782"},{"fieldName":"PRCDSCD","fieldValue":"26.97495"},{"fieldName":"PRCDSCE","fieldValue":"34.68208"},{"fieldName":"PRCDSCF","fieldValue":"38.53565"},{"fieldName":"PRCMNDT","fieldValue":"20170517"},{"fieldName":"PRCMNTM","fieldValue":"0"}],[{"fieldName": "PRCSCHCD","fieldValue": "A151"}]]}';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SBQQDiscountScheduleService.insertAndUpdate();
        Test.stopTest();
    }
    public static testMethod void method1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        String json ='{"tableName": "PRSPRCSCH","uniqueFieldName": "PRCSCHCD","tableData": [[{"fieldName": "PRCSCHCD","fieldValue": "A101"},{"fieldName":"PRCDSCB","fieldValue":"11.56069"},{"fieldName":"PRCDSCC","fieldValue":"19.26782"},{"fieldName":"PRCDSCD","fieldValue":"26.97495"},{"fieldName":"PRCDSCE","fieldValue":"34.68208"},{"fieldName":"PRCDSCF","fieldValue":"38.53565"},{"fieldName":"MNTDT","fieldValue":"20170517"},{"fieldName":"MNTTM","fieldValue":"0"}],[{"fieldName": "PRCSCHCD","fieldValue": "A151"}]]}';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SBQQDiscountScheduleService.insertAndUpdate();
        Test.stopTest();
    }
    public static testMethod void method4(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PRCSCHCD';
        dyTbleMap.Db_Table_Name__c = 'PRSPRCSCH';
        dyTbleMap.Sf_Field_Name__c = 'PRSPRCSCH__c';
        dyTbleMap.Sf_Table_Name__c = 'SBQQ__DiscountSchedule__c';
        insert dyTbleMap;
        
        SBQQ__DiscountSchedule__c discountSchedule = new SBQQ__DiscountSchedule__c();
        discountSchedule.Name = 'A101';
        insert discountSchedule;
        String json ='{"tableName": "PRSPRCSCH","uniqueFieldName": "PRCSCHCD","tableData": [[{"fieldName":"PRCDSCB","fieldValue":"11.56069"},{"fieldName":"PRCDSCC","fieldValue":"19.26782"},{"fieldName":"PRCDSCD","fieldValue":"26.97495"},{"fieldName":"PRCDSCE","fieldValue":"34.68208"},{"fieldName":"PRCDSCF","fieldValue":"38.53565"},{"fieldName":"PRCMNDT","fieldValue":"20170517"},{"fieldName":"PRCMNTM","fieldValue":"0"}],[{"fieldName": "PRCSCHCD","fieldValue": "A151"}]]}';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SBQQDiscountScheduleService.insertAndUpdate();
        Test.stopTest();
    }
    public static testMethod void exceptionMethod(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        String json ='{}';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SBQQDiscountScheduleService.insertAndUpdate();
        Test.stopTest();
    }
}
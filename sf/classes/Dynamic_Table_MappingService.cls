@RestResource(urlMapping='/insertAndUpdateProduct/*')
global class Dynamic_Table_MappingService {
    
    //For getting record type id of table
    global static Id getRecordTypeId(String tableName){
        Id recordTypeId;
        if(tableName.equalsIgnoreCase('PRSPATFL')){
            recordTypeId=[SELECT Id FROM RecordType WHERE DeveloperName = 'Product_Pattern_Woven_Finished_Good' limit 1].Id; 
        }else if(tableName.equalsIgnoreCase('PRSCLRFL')){           
            recordTypeId=[SELECT Id FROM RecordType WHERE DeveloperName = 'Product_Color' limit 1].Id; 
        }else if(tableName.equalsIgnoreCase('PRSFINFL')){
            recordTypeId=[SELECT Id FROM RecordType WHERE DeveloperName = 'Finish' limit 1].Id;
        }else if(tableName.equalsIgnoreCase('PRSBRAND') ){
            recordTypeId=[SELECT Id FROM RecordType WHERE DeveloperName = 'Brand' limit 1].Id;
        }else if(tableName.equalsIgnoreCase('PRSHOTEL') ){
            recordTypeId=[SELECT Id FROM RecordType WHERE DeveloperName = 'Hotel_Company' limit 1].Id;
        }
        
        return recordTypeId;
    }
    
    global static Map<String,Id> getAccountRecordTypeId(){
        List<RecordType> recordTypeList = [SELECT Id,Name,DeveloperName FROM RecordType WHERE SobjectType = 'account'];   
        Map<String,Id> recordTypeMap = new Map<String,Id>();
        for(RecordType recordType : recordTypeList){
            recordTypeMap.put(recordType.Name,recordType.Id);
        }
        return recordTypeMap;
    }
    
    //for getting DB to SF fields mapping
    global static Map<String,Object> getDbToSfFieldMapping(List<Dynamic_Table_Mapping__c> mappingList){
        Map<String,Object> sfObjectsMap = new Map<String,Object>();
        
        for(Dynamic_Table_Mapping__c dynamicTemp : mappingList){
            sfObjectsMap.put(dynamicTemp.Db_Field_Name__c, dynamicTemp.Sf_Field_Name__c);
        }
        
        return sfObjectsMap;
    }
    
    //For getting Dynamic_Table_Mapping List
    global static List<Dynamic_Table_Mapping__c> getDynamic_Table_MappingListByDB(String DbTableName){
        List<Dynamic_Table_Mapping__c> sfObjectNamesList = [SELECT Db_Lookup_Name__c,Sf_Lookup_Name__c,Db_Field_Name__c,Db_Table_Name__c,Sf_Field_Name__c,Sf_Table_Name__c FROM Dynamic_Table_Mapping__c WHERE Db_Table_Name__c =: DbTableName];
        return sfObjectNamesList;
    }
    
    global static Map<String,Object> getLookupFields(List<Dynamic_Table_Mapping__c> mappingList){
        Map<String,Object> sfObjectsMap = new Map<String,Object>();
        Map<String,String> sfLookupMap = new Map<String,String>();
        Map<String,String> dbLookupMap = new Map<String,String>();
        
        for(Dynamic_Table_Mapping__c dynamicTemp : mappingList){
            sfLookupMap.put(dynamicTemp.Db_Field_Name__c, dynamicTemp.Sf_Lookup_Name__c);
            dbLookupMap.put(dynamicTemp.Db_Field_Name__c, dynamicTemp.Db_Lookup_Name__c);
        }
        
        sfObjectsMap.put('sfLookupMap', sfLookupMap); 
        sfObjectsMap.put('dbLookupMap', dbLookupMap);
        
        return sfObjectsMap;
    }
    
    @HttpPost
    global static void insertAndUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Map<String,String>> responseList = new List<Map<String,String>>();
        try{
            System.debug(req);
            Map<String, object> restValues = RestfulServiceUtils.parseJsonFromRequest(req);
            List<Object> tableDataMultiList = (List<Object>)restValues.get('tableData');
            String DbTableName = (String)restValues.get('tableName');
            String uniqueColummName = (String)restValues.get('uniqueFieldName');
            List<Dynamic_Table_Mapping__c> sfObjectNamesList = getDynamic_Table_MappingListByDB(DbTableName);
            
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sfObjectNamesList.get(0).Sf_Table_Name__c);       
            
            Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
            SObject obj;   
            String className = sobjResult.getName();
            Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject(className);
            
            Id recordTypeId = getRecordTypeId(DbTableName);
            Map<String,Id> recordTypeMap = getAccountRecordTypeId();
            Map<String,Object> mapSfObjectList = getDbToSfFieldMapping(sfObjectNamesList);
            Map<String,Object> sfObjectsMap = getLookupFields(sfObjectNamesList);
            Map<String,String> sfLookupMap = (Map<String,String>)sfObjectsMap.get('sfLookupMap');
            Map<String,String> dbLookupMap = (Map<String,String>)sfObjectsMap.get('dbLookupMap');
            Map<String, Schema.SObjectField> schemaFieldMap = sobjResult.fields.getMap();
            List<String> externalIdsList = new List<String>();
            
            for(Object tableData : tableDataMultiList){
                List<Object> tableDataList = (List<Object>)tableData; 
                obj = targetType.newSObject();
                String externalId = null;
                for(Object mapdata : tableDataList){
                    
                    Map<String,Object> tableDataMap = (Map<String,Object> )mapdata;
                    String fieldName = (String)tableDataMap.get('fieldName');
                    Object value = tableDataMap.get('fieldValue');
                    
                    //System.debug('*************************'+(String)mapSfObjectList.get(fieldName));
                    if(schemaFieldMap.get((String)mapSfObjectList.get(fieldName))!=null){
                        System.debug('************* '+fieldName);
                        if(fieldName.equalsIgnoreCase(uniqueColummName)){   
                            externalId = DbTableName+(String)value;
                            obj.put('External_Field_Id__c',externalId);
                        } 
                        
                        if(fieldName.equalsIgnoreCase('STATUS') && ((String)value).equalsIgnoreCase('D')){
                            externalIdsList.add(externalId);
                        }
                        
                        Schema.DisplayType fieldType = schemaFieldMap.get((String)mapSfObjectList.get(fieldName)).getDescribe().getType();
                        if(value!=null && String.valueOf(value).trim() != ''){
                            if(fieldType == Schema.DisplayType.DateTime){
                                obj.put(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),DateTime.valueOf(value).format('yyyy-MM-dd HH:mm:ss'));
                            }else if(fieldType == Schema.DisplayType.Date){
                                Date datevalue = Date.valueOf(value);
                                obj.put(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),DateTime.newInstance(datevalue.year(),datevalue.month(),datevalue.day()).format('yyyy-MM-dd'));
                            }else if(fieldType  == Schema.DisplayType.Integer){
                                obj.put(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),Integer.valueOf(value));
                            }else if(fieldType  == Schema.DisplayType.CURRENCY){
                                obj.put(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),Double.valueOf(value));
                            }else if(fieldType  == Schema.DisplayType.Double){
                                obj.put(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),Double.valueOf(value));
                            }else if(fieldType  == Schema.DisplayType.REFERENCE) {
                                sObject sObj = Schema.getGlobalDescribe().get(sfLookupMap.get(fieldName)).newSObject();
                                sObj.put('External_Field_Id__c',dbLookupMap.get(fieldName)+(String)value);
                                
                                obj.putSObject(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)), sObj);
                                //obj.putSobject(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),string.valueOf(value));
                            }else{
                                obj.put(schemaFieldMap.get((String)mapSfObjectList.get(fieldName)),string.valueOf(value));
                            }
                        }
                        
                    }
                    
                }
                if('PRSCUSTFL'.equalsIgnoreCase(DbTableName)){
                    String pcsclass = String.valueOf(obj.get('PCSCLAS__c')); 
                    String recordType;
                    if(pcsclass == null || pcsclass == 'Purchaser' || pcsclass == 'Designer' || pcsclass == 'Purchasing Company'){
                        recordType = recordTypeMap.get('Purchaser / Designer');
                    }else if(pcsclass == 'Fabricator'){
                        recordType = recordTypeMap.get('Fabricator');
                    }else if(pcsclass == 'Brand'){
                        recordType = recordTypeMap.get('Brand');
                    }else if(pcsclass == 'Hotel Property Direct'){
                        recordType = recordTypeMap.get('Hotel Company');
                    }else if(pcsclass == 'Ownership'){
                        recordType = recordTypeMap.get('Ownership Group');
                    }

                    obj.put('recordtypeid', recordType);
                }else if(recordTypeId!=null){
                    obj.put('recordtypeid', recordTypeId);
                }   
                upsertDynamicSobject.addSfObject(obj);
            }    
            responseList=upsertDynamicSobject.upsertSobjects();
            System.debug('list of ids : '+externalIdsList);
            String query = 'select id from '+sfObjectNamesList.get(0).Sf_Table_Name__c+' WHERE External_Field_Id__c IN :externalIdsList and External_Field_Id__c != null';
            List<SObject> deleteList = Database.query(query);
            delete deleteList;            
        }catch(Exception e){
            Log__c lg = new Log__c();
            lg.Class_Name__c = 'Dynamic_Table_MappingService';
            lg.Exception_Message__c = e.getStackTraceString() + e.getMessage();
            lg.Method_Name__c = 'insertAndUpdate';
            lg.Input_Data__c = req.requestBody.toString();
            insert lg;
            Map<String,String> exceptionResultMap = new Map<String,String>();
            exceptionResultMap.put('Status','false');
            exceptionResultMap.put('error',e.getStackTraceString()+e.getmessage());
            res.statusCode = 400;
        }
        Map<String,String> responseMap = new Map<String,String>();
        responseMap.put('Status', 'No Failures....');
        res.responseBody = RestfulServiceUtils.parseValToJson(responseList.size()==0?new List<Map<String,String>>{responseMap}:responseList);        
    }
    
}
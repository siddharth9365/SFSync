@RestResource(urlMapping='/SBQQDiscountScheduleService/*')
global class SBQQDiscountScheduleService {
    
    //For getting status messages of database
    public List<Map<String,String>> getDMLStatusMessages(Database.UpsertResult [] cr){
        Map<String,String> successMap; 
        List<Map<String,String>> successList=new List<Map<String,String>>();
        Set<Id> setSuccessIds = new Set<Id>();
        
        for(Database.UpsertResult p : cr){
            successMap = new Map<String,String>();
            if(p.isSuccess()){
               // successMap.put('Status', 'success');
               // successMap.put('SfId', p.getId());
               // setSuccessIds.add(p.getId());
            }else{
                for(Database.Error er : p.getErrors()){
                    successMap.put('Error ', er.getMessage());
                }
                successMap.put('Status', 'Fail');
                successList.add(successMap);
            }
            
        }
        return successList;
    }
	@HttpPost
    global static void insertAndUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Map<String,String>> responseList;
        try{
            Map<String, object> restValues = RestfulServiceUtils.parseJsonFromRequest(req);
            List<Object> tableDataMultiList = (List<Object>)restValues.get('tableData');
            String DbTableName = (String)restValues.get('tableName');
            String uniqueColummName = (String)restValues.get('uniqueFieldName');
            List<String> namesList = new List<String>();
            for(Object tableData : tableDataMultiList){
                List<Object> tableDataList = (List<Object>)tableData; 
                //obj = targetType.newSObject();
                for(Object mapdata : tableDataList){
                    Map<String,Object> tableDataMap = (Map<String,Object> )mapdata;
                    String fieldName = (String)tableDataMap.get('fieldName');
                    Object value = tableDataMap.get('fieldValue');
                    
                    if(fieldName.equalsIgnoreCase(uniqueColummName)){      
	                    namesList.add((String)value);
	                }
                    
                }     
            }
            System.debug('name List : '+namesList);
            Map<String,String> nameMap = new Map<String,String>();
            for(String name : namesList){
                nameMap.put(name,null);
            }
            List<SBQQ__DiscountSchedule__c> dicountList = [SELECT Id,name from SBQQ__DiscountSchedule__c where name in :namesList];
            Map<String,SBQQ__DiscountSchedule__c> dcmap = new Map<String,SBQQ__DiscountSchedule__c>();
            for(SBQQ__DiscountSchedule__c d : dicountList){
				dcmap.put(d.name,d);
			}
             System.debug(dcmap);
            List<SBQQ__DiscountTier__c> finalDiscountTierList = new List<SBQQ__DiscountTier__c>();
            List<SBQQ__DiscountTier__c> failureDiscountTierList = new List<SBQQ__DiscountTier__c>();
            
            for(Object tableData : tableDataMultiList){
                List<Object> tableDataList = (List<Object>)tableData; 
                //obj = targetType.newSObject();
                List<SBQQ__DiscountTier__c> discountTierList = new List<SBQQ__DiscountTier__c>();
                SBQQ__DiscountSchedule__c dicountSchedule = new SBQQ__DiscountSchedule__c();
                SBQQ__DiscountTier__c discountTier;
                String MNTDT;
                String MNTTM;
                for(Object mapdata : tableDataList){
                    Map<String,Object> tableDataMap = (Map<String,Object> )mapdata;
                    String fieldName = (String)tableDataMap.get('fieldName');
                    Object value = tableDataMap.get('fieldValue');
                    
                    if(fieldName.equalsIgnoreCase(uniqueColummName)){ 
	                    dicountSchedule = dcmap.get(String.valueOf(value));
                    }else if(fieldName.equalsIgnoreCase('PRCDSCB')){
                        discountTier = new SBQQ__DiscountTier__c();
                        discountTier.Name = 'B';
                        discountTier.SBQQ__Discount__c = Double.valueOf(value);	
                        String scheduleId = dicountSchedule!=null?dicountSchedule.Id+'B':null;
						discountTier.External_Field_Id__c = scheduleId;
                        discountTierList.add(discountTier);
                    }else if(fieldName.equalsIgnoreCase('PRCDSCC')){
                        discountTier = new SBQQ__DiscountTier__c();
                        discountTier.Name = 'C';
                        discountTier.SBQQ__Discount__c = Double.valueOf(value);
                        String scheduleId = dicountSchedule!=null?dicountSchedule.Id+'C':null;
						discountTier.External_Field_Id__c = scheduleId;
                        discountTierList.add(discountTier);
                    }else if(fieldName.equalsIgnoreCase('PRCDSCD')){
                        discountTier = new SBQQ__DiscountTier__c();
                        discountTier.Name = 'D';
                        discountTier.SBQQ__Discount__c = Double.valueOf(value);
                        String scheduleId = dicountSchedule!=null?dicountSchedule.Id+'D':null;
						discountTier.External_Field_Id__c = scheduleId;
                        discountTierList.add(discountTier);
                    }else if(fieldName.equalsIgnoreCase('PRCDSCE')){
                        discountTier = new SBQQ__DiscountTier__c();
                        discountTier.Name = 'E';
                        discountTier.SBQQ__Discount__c = Double.valueOf(value);
						String scheduleId = dicountSchedule!=null?dicountSchedule.Id+'E':null;
						discountTier.External_Field_Id__c = scheduleId;
                        discountTierList.add(discountTier);
                    }else if(fieldName.equalsIgnoreCase('PRCDSCF')){
                        discountTier = new SBQQ__DiscountTier__c();
                        discountTier.Name = 'F';
                        discountTier.SBQQ__Discount__c = Double.valueOf(value);
                        String scheduleId = dicountSchedule!=null?dicountSchedule.Id+'F':null;
						discountTier.External_Field_Id__c = scheduleId;
                        discountTierList.add(discountTier);
                    }else if(fieldName.equalsIgnoreCase('MNTDT')) {
                        MNTDT = String.valueOf(value);
                    }else if(fieldName.equalsIgnoreCase('MNTTM')) {
                        MNTTM = String.valueOf(value);
                    }
                }
                if(dicountSchedule!=null){
                    for(SBQQ__DiscountTier__c d :discountTierList){
                        d.SBQQ__Schedule__c = dicountSchedule.Id;
                        d.MNTDT__c = MNTDT;
                        d.MNTTM__c = MNTTM;
                	}
                    nameMap.remove(dicountSchedule.name);
                    finalDiscountTierList.addAll(discountTierList);
                }else{
                    failureDiscountTierList.addAll(discountTierList);
                }
            }
            Schema.SObjectField f = SBQQ__DiscountTier__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(finalDiscountTierList, f, false);
            SBQQDiscountScheduleService discountScheduleService = new SBQQDiscountScheduleService();
            responseList = discountScheduleService.getDMLStatusMessages(cr);
            Map<String,String> responseMap = new Map<String,String>();
            if(failureDiscountTierList.size() > 0){
                for(String name : nameMap.keySet()){
                   responseMap.put(name, 'Fail');
                }
            }else{
                responseMap.put('Status', 'No Failures....');
            }
        	res.responseBody = RestfulServiceUtils.parseValToJson(responseList.size()==0?new List<Map<String,String>>{responseMap}:responseList);
        }catch(Exception e){
            Log__c lg = new Log__c();
            lg.Class_Name__c = 'SBQQDiscountScheduleService';
            lg.Exception_Message__c = e.getStackTraceString() + e.getMessage();
            lg.Method_Name__c = 'insertAndUpdate';
            lg.Input_Data__c = req.requestBody.toString();
            insert lg;
            Map<String,String> exceptionResultMap = new Map<String,String>();
            exceptionResultMap.put('Status','false');
            exceptionResultMap.put('error',e.getStackTraceString()+e.getmessage());
            res.statusCode = 400;
        }
    }
}
public class SM008_Utils 
{
  /* equals map.putAll, but for specific keyName<>'id'
     */
    public static map<string,sobject> getMap(list<sobject> lObj, string keyName)
    {
    	map<string,sobject>mret = new map<string,sobject>();
    	for(sobject sobj: lObj)
    	{
    		mret.put((string)sobj.get(keyName),sobj);	
    	}
    	return mret;
    }
    
    public static map<string,sobject> getMap(list<sobject> lObj)
    {
    	return getMap(lobj,'id');
    }
    
     
    public static map<string,list<sobject>> groupBy(list<sobject> lFlatObj, string keyName)
    {
    	map<string,list<sobject>>mret = new map<string,list<sobject>>();
    	for(sobject sobj: lFlatObj)
    	{
            string keyValue = (string)sobj.get(keyName);
            list<sobject> lObj = mret.get(keyValue);
            if(lObj == null)
            {
                lObj = new list<sobject>();
                lObj.add(sobj);
                mret.put(keyValue, lObj);
            }
            else
            {
                lObj.add(sobj);
            }
    	}
    	return mret;      
    }
   
    
    /* used when you want to convert JSON.deserializeUntyped output to list<map<string,object>> which usually represents a list of records
     */
    public static list<map<string,object>>listOfMap(list<object> lobj)
    {
    	list<map<string,object>> lresp = new list<map<string,object>>();
        for (object o :lobj)
        {
            lresp.add((map<string,object>)o);
        }
        return lresp;
    }
    
    public static string getMapValue(map <string,sobject> mVal,string keyValue,string targetFieldName)
    {
        string ret;
        system.debug('getMapValue mVal');
        system.debug(mVal);
        sobject o = mVal.get(keyValue);
        
        if (o != null)
        {
            system.debug('found custom settings');
            system.debug(o);
            ret = (string) o.get(targetFieldName);
        }
        return ret;
    }
    
    public static string replaceMatch(string sStr, string regex)
    {
        return replaceMatch(sStr,regex, '');
    }
	public static string replaceMatch(string sStr, string regex, string sTo)
    {
        Pattern regexPattern = Pattern.compile(regex);
        Matcher regexMatcher = regexPattern.matcher(sStr);
        if(regexMatcher.find()) {
           sStr = sStr.replaceAll(regex, sTo);
        }
        system.debug('replaceMatch return is: '+sStr);
        return sStr;
        
    }
    
    public static string digitsOnly(string sStr)
    {
        return replaceMatch(sStr,'\\D+');
    }
    
    public static string charsOnly(string sStr)
    {
        
        return sStr;
    }
    
    public static string noCommas(string sStr)
    {
        return replaceMatch(sStr,'[.,:;\'"]');
    }
    
    public static list<sobject> queryByField(string sObjName, string sKeyName,set<string> sVal)
    {
        string sQuery = 'select id, '+sKeyName+' from '+sObjName+' where '+sKeyName+' in :sVal';
        list<sobject> lret = Database.query(sQuery);
		return lret;        
    }
    public static void upsertObj(list<sobject>lObj, string sObjName, string sKeyName)
    {
        list<sobject> lupdate = new list<sobject>();
        list<sobject> linsert = new list<sobject>();
        map<string,sobject> mObj = SM008_Utils.getMap(lObj,sKeyName);
        list<sobject>lOldObj = SM008_Utils.queryByField(sObjName, sKeyName,mObj.keySet());
        map<string,sobject> mOldObj = SM008_Utils.getMap(lOldObj,sKeyName);
        for(string sKey:mObj.keySet())
        {
            sobject oNew = mObj.get(sKey);
            sobject oOld = mOldObj.get(sKey);
            if(oOld == null)
            {   
                linsert.add(oNew);
            }
            else
            {
                onew.put('id', oold.get('id'));
                onew.put(sKeyName, oold.get(sKeyName));
                lupdate.add(onew);
            }
        }
        system.debug('upsertObj: lupdate:');
        system.debug(lupdate);
        
        update lupdate;
        
        system.debug('upsertObj: linsert:');
        system.debug(linsert);
        
        insert linsert;        
    }
    
    public static boolean isEmpty(string sVal)
    {
        if(sVal == null)
            return true;
        sVal = sVal.trim();
       	if (sVal.length()==0)
            return true;
        return false;
    }
    
    /*    public static list<string> listFieldValues(list<SObject> lObj, string sFieldName)
    {
    	list<string> lRet = new list <string>();
    	
    	for (sObject obj: lObj)
    	{
    		lRet.add((string)(obj.get(sFieldName)));	
    	}
    	return lRet;
    }
*/
    
       /*
     * Equals to SM008_Utils.getMap(lArr,keyName).keySet();
     */
 /*   public static set<string> getSet(list<sobject> lObj,string keyName)
    {
    	set<string>sret = new set<string>();
    	for(sobject sobj: lObj)
    	{
    		sret.add((string)sobj.get(keyName));	
    	}
    	return sret;    
    } 
*/
     /* 
    public static map<string,object> findEqual(list<map<string,object>>lObj,string keyName, object keyValue)
    {
       system.debug('SM008_Utils.findEqual begin'); 
        map<string,object> mret = null;
        for(map<string,object> m: lobj)
        {
			system.debug(m);
			object o = m.get(keyName);            
            if(o != null && o.equals(keyValue))
            {
                mret = m;
                break;
            }
        }
        
        return mret;
    }
*/   
}
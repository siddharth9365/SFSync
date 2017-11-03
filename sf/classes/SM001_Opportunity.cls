public class SM001_Opportunity 
{
	public static void populateSplit(list<opportunity> lNew, map<id,opportunity> mOld)
    {
        map <id, opportunity> mUpdated = new map<id,opportunity>();
        set<id> sAccId = new set<id>();
        
        for(opportunity opty : lnew)
        {
            id newPurchAccId = opty.Purchaser_Account__c;
            id oldpurchAccId = null;
            if(mOld != null)
            {
                opportunity old = mOld.get(opty.id);
                if(old != null)
                {
                    oldpurchAccId = old.Purchaser_Account__c;
                }
            }
            if(newPurchAccId != oldpurchAccId)
            {
                mUpdated.put(opty.id, opty);
                sAccId.add(opty.Purchaser_Account__c);
                sAccId.add(opty.AccountId);
            }
        }
		set<id>sId2 = new set<id>();
        if(!mUpdated.isEmpty())
        {
   			set<id> sOptyId = mUpdated.keySet();                 
            list<OpportunitySplit> lSplit = 
			[
                select id, OpportunityId, Split, SplitAmount, SplitNote, SplitOwnerId, SplitPercentage, SplitTypeId 
                from OpportunitySplit  
                where opportunityId in :sOptyId              	  
            ];
            map<string,list<sobject>> mOptySplit = SM008_Utils.groupBy(lSplit, 'opportunityid');  
            
            for(string sid: mupdated.keySet())
            {
                opportunity opty = mupdated.get(sid);
                list<sobject> lsplits = mOptySplit.get(sid);
                if(lsplits.size()>1)
                {
                    opty.addError('It\'s not possible to Add Project Split since there are 2 split records already.');
                }
                else
                {
                    sid2.add(opty.id);
                }
            }
        }
        if(!sid2.isEmpty())
        {
            split(sid2);
        }
    }
    
 //   @future(CallOut=true)
    public static void split(set<id>sOptyId)
    {
//        system.debug('futureSplit '+sOptyId);
        list<opportunity> lOpty= 
            [
                select id, accountId, Purchaser_Account__c from opportunity where id in :sOptyId
            ];
        map<id,opportunity> mOpty = new map<id,opportunity>();
        set<id>sAccId = new set<id>();
        for(opportunity opty: lOpty)
        {
            mOpty.put(opty.id, opty);
            if(opty.AccountId != null)
            	sAccid.add(opty.AccountId);
            if(opty.Purchaser_Account__c != null)
            	sAccid.add(opty.Purchaser_Account__c);                
        }
        
        list<account> lAcc = [select id,ownerId from account where id in :sAccId];
        map<string, sobject> mAcc = SM008_Utils.getMap(lAcc);

        list<OpportunityTeamMember> lMem = 
            [
                select id,userid,teammemberrole,opportunityid
                from OpportunityTeamMember 
                where opportunityId in :sOptyId //and teammemberrole = 'Purchaser Account Representative'
            ];
        
        map<string,list<sobject>> mOptyMem = SM008_Utils.groupBy(lMem, 'opportunityid');

        list<OpportunitySplit> lSplit = 
            [
                select id, OpportunityId, Split, SplitAmount, SplitNote, SplitOwnerId, SplitPercentage, SplitTypeId 
                from OpportunitySplit  
                where opportunityId in :sOptyId              	  
            ];
        map<string,list<sobject>> mOptySplit = SM008_Utils.groupBy(lSplit, 'opportunityid');  

        list<sobject> linsert = new list<sobject>();
        list<sobject> lupdate = new list<sobject>(); 
        for (id optyId : sOptyId)
        {
            opportunity opty = mOpty.get(optyId);
            if(opty != null && opty.Purchaser_Account__c != null)
            {
                account acc2 = (account)mAcc.get(opty.Purchaser_Account__c);
				if(acc2 != null && acc2.OwnerId != null)
                {
                    list<sobject> lSplit1 = mOptySplit.get(optyId);
                    if(lSplit1.size() == 1)
                    {
                        
                        OpportunitySplit split1 = (OpportunitySplit) lSplit.get(0);
                        if(split1.SplitOwnerId != acc2.OwnerId)
                        {
           //                 split1.SplitPercentage = 0.75;
          //                  lupdate.add(split1);
                            
                            OpportunitySplit split2 = new OpportunitySplit();
                            split2.OpportunityId = split1.OpportunityId;
                            split2.SplitOwnerId =  acc2.OwnerId;  
                            split2.SplitPercentage = 25;
                            linsert.add(split2);
                        }
                    }
                    boolean bMemberExists = false;
                    list <sobject> lteam = mOptyMem.get(optyId);
                    if(lteam != null)
                    {
                        for(sobject obj: lteam)
                        {
                            OpportunityTeamMember mem = (OpportunityTeamMember) obj;
                            if(mem.UserId == acc2.OwnerId)
                            {
                                bMemberExists = true;
                                break;
                            }
                        }
                    }
                    if(!bMemberExists)
                    {
                        OpportunityTeamMember mem = new OpportunityTeamMember();
                        mem.OpportunityId = optyId;
                        mem.UserId = acc2.OwnerId;
                        mem.teammemberrole = 'Purchaser Account Representative';
                        linsert.add(mem);
                    }
                }
            }
        }
        if(!lupdate.isEmpty())
            update lupdate;
        if(!linsert.isEmpty())
            insert linsert;
    }
}
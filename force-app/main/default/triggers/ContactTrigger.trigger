trigger ContactTrigger on Contact (after update) 
{
   /* for(Contact con:Trigger.New)
    {
        if(con.Member_Status__c == 'InActive' && con.Inactive_reason__c != Trigger.oldMap.get(con.Id).Inactive_reason__c)
        {
           con.Inactive_reason__c.addError('Cannot Edit');
        }
    }*/

}
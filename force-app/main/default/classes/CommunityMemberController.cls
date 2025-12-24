/**
* @File Name : CommunityMemberController .cls
* @Description :This class is to get the community members who's status is pending
* @Author :Sivalingam S
* @Last Modified On : December 9, 2025

*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 9, 2025 |   | Initial Version
**/

public class CommunityMemberController 
{
    @AuraEnabled(cacheable=true)
    public static List<Community_Member_Registration_Form__c> getCommunityMembers()
    {
     
        return  [SELECT Id, First_Name__c,Last_Name__c, Email__c, Approval_Status__c, Mobile_Number__c, CreatedDate,Address_Line_1__c,Gender__c,State__c, City__c,Zipcode__c,Proof_of_Identity__c,Occupation__c,Country__c  
                 FROM Community_Member_Registration_Form__c
                 WHERE Approval_Status__c = 'Pending'
                 ORDER BY CreatedDate DESC];
    }
    
    @AuraEnabled
    public static void updateStatus(Id recordId, String status, string approveReason, string rejectReason)
    {
      
       update new Community_Member_Registration_Form__c(Id = recordId, Approval_Status__c =status, Approve_Reason__c=approveReason, Rejection_Reason__c=rejectReason);
      
    }
    
}
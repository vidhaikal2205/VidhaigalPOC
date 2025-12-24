/**
* @File Name : CheckMemberStatusController .cls
* @Description :This class is create to check the member status by email
* @Author :Neelima
* @Last Modified On : December 5, 2025

*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 5, 2025 |   | Initial Version
**/

public with sharing class CheckMemberStatusController {

    @AuraEnabled(cacheable=true)
    public static string  isEmailRegistered(String email) {
        if (String.isBlank(email)) {
            return 'EMPTY';
        }
       
        List<Community_Member_Registration_Form__c> found = [
            SELECT Id,Approval_Status__c    
            FROM Community_Member_Registration_Form__c 
            WHERE Email__c = :email
            LIMIT 1

        ];
		if(found.isEmpty()){
			return 'Not_Found';
		}
        return found[0].Approval_Status__c;
    }
}
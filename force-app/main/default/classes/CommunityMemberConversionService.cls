public with sharing class CommunityMemberConversionService {

    @AuraEnabled
    public static Id convertRegistrationToContact(Id registrationId) {

        System.debug('### START convertRegistrationToContact ###');
        System.debug('Registration Id received: ' + registrationId);

        // Fetch Registration record
       Community_Member_Registration_Form__c reg = [
            SELECT Id, Salutation__c, First_Name__c, Last_Name__c, Email__c,
                   Mobile_Number__c, Gender__c, Occupation__c, Annual_Income__c,
                   State__c, Address_Line_1__c, Address_Line_2__c,
                   City__c, Zipcode__c,Country__c
            FROM Community_Member_Registration_Form__c
            WHERE Id = :registrationId
            LIMIT 1
        ];

        System.debug('Fetched Registration Record: ' + reg);

        // Get Contact Record Type
        List<RecordType> rtList = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Contact'
            AND DeveloperName = 'Community_Member'
            LIMIT 1
        ];

        if (rtList.isEmpty()) {
            System.debug('Contact RecordType Community_Member not found');
            throw new AuraHandledException('Contact Record Type not found');
        }

        Id contactRtId = rtList[0].Id;
        System.debug('Community Member Contact RecordType Id: ' + contactRtId);

        
        //  Create Contact
        Contact con = new Contact();

        // Basic Info
        con.Salutation   = reg.Salutation__c;
        con.FirstName    = reg.First_Name__c;
        con.LastName     = String.isBlank(reg.Last_Name__c)
                           ? 'Community Member'
                           : reg.Last_Name__c;
        con.Email        = reg.Email__c;
        con.MobilePhone  = reg.Mobile_Number__c;

        // Custom Fields
        con.GenderIdentity     = reg.Gender__c;
        con.Occupation__c     = reg.Occupation__c;
        con.Annual_Income__c  = reg.Annual_Income__c;

        // Address
        con.MailingStreet =
            reg.Address_Line_1__c +
            (String.isNotBlank(reg.Address_Line_2__c)
                ? ', ' + reg.Address_Line_2__c
                : '');

        con.MailingCity       = reg.City__c;
        con.MailingState      = reg.State__c;
        con.MailingPostalCode = String.valueOf(reg.Zipcode__c);
        con.MailingCountry = reg.Country__c;
        con.RecordTypeId = contactRtId;
	    System.debug('Contact before insert: ' + con);
        insert con;
        System.debug('Contact successfully created. Contact Id: ' + con.Id);      
        return con.Id;
    }
}
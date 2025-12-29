@IsTest
public class CommunityMemberConversionServiceTest 
{
    @IsTest
    static void testConvertRegistrationToContact_RecordType() 
    {

        // Step 1: Fetch Community Member Contact Record Type
        RecordType communityRt = [
            SELECT Id, DeveloperName, Name
            FROM RecordType
            WHERE SObjectType = 'Contact'
              AND DeveloperName = 'Community_Member'
            LIMIT 1
        ];

        System.assertNotEquals(
            null,
            communityRt,
            'Community Member Record Type must exist'
        );

        // Step 2: Create Community Member Registration record
        Community_Member_Registration_Form__c registration =
            new Community_Member_Registration_Form__c(
                Salutation__c = 'Mr.',
                First_Name__c = 'Test',
                Last_Name__c = 'User',
                Email__c = 'testuser@gmail.com',
                Mobile_Number__c = '9999999999',
                Gender__c = 'Male',
                Occupation__c = 'Salaried',
                Annual_Income__c = 50000,
                State__c = 'Assam',
                Address_Line_1__c = '123 Test St',
                Address_Line_2__c = 'Apt 1',
                City__c = 'Guwahati',
                Zipcode__c = 781001,
                Country__c = 'India',
                Confirm_Email__c = 'testuser@gmail.com',
                Proof_of_Identity__c = 'Aadhar',
                Password__c = 'Test@1234'
            );

        insert registration;

        // Step 3: Call conversion method
        System.Test.startTest();
        Id contactId =
            CommunityMemberConversionService.convertRegistrationToContact(
                registration.Id
            );
        System.Test.stopTest();

        // Step 4: Fetch created Contact
        Contact con = [
            SELECT Id,
                   Salutation,
                   FirstName,
                   LastName,
                   Email,
                   MobilePhone,
                   MailingStreet,
                   MailingCity,
                   MailingState,
                   MailingPostalCode,
                   MailingCountry,
                   Member_Status__c,
                   RecordTypeId,
                   RecordType.Name
            FROM Contact
            WHERE Id = :contactId
        ];

        // Step 5: Assertions
        System.assertEquals('Mr.', con.Salutation);
        System.assertEquals('Test', con.FirstName);
        System.assertEquals('User', con.LastName);
        System.assertEquals('testuser@gmail.com', con.Email);
        System.assertEquals('9999999999', con.MobilePhone);
        System.assertEquals('Guwahati', con.MailingCity);
        System.assertEquals('Assam', con.MailingState);
        System.assertEquals('781001', con.MailingPostalCode);
        System.assertEquals('India', con.MailingCountry);
        System.assertEquals('Active', con.Member_Status__c);

        System.assertEquals(
            communityRt.Id,
            con.RecordTypeId,
            'Contact must be created with Community Member Record Type'
        );

        System.assertEquals(
            'Community Member',
            con.RecordType.Name,
            'Record Type name must be Community Member'
        );
    }
}


/*
    @IsTest
    static void testConvertRegistrationToContact_RecordType() {
        // Step 1: Get the Community Member Record Type
        RecordType communityRt = [
            SELECT Id, DeveloperName, Name 
            FROM RecordType 
            WHERE SObjectType = 'Contact' 
              AND DeveloperName = 'Community_Member' 
            LIMIT 1
        ];

        System.assertNotEquals(null, communityRt, 'Community Member Record Type must exist');

        // Step 2: Create a test Community Member Registration record
        Community_Member_Registration_Form__c registration = new Community_Member_Registration_Form__c(
            Salutation__c = 'Mr.',
            First_Name__c = 'Test',
            Last_Name__c = 'User',
            Email__c = 'testuser@gmail.com',
            Mobile_Number__c = '9999999999',
            Gender__c = 'Male',
            Occupation__c = 'Salaried',
            Annual_Income__c = 50000,
            State__c = 'Assam',
            Address_Line_1__c = '123 Test St',
            Address_Line_2__c = 'Apt 1',
            City__c = 'Guwahati',
            Zipcode__c = 781001,
            Country__c='India',
            Confirm_Email__c='testuser@gmail.com',
            Proof_of_Identity__c='Aadhar',
            Password__c='test@123'
             );
        insert registration;

        // Step 3: Call the method to convert registration to Contact
        System.Test.startTest();
        Id contactId = CommunityMemberConversionService.convertRegistrationToContact(registration.Id);
        System.Test.stopTest();

        // Step 4: Retrieve the created Contact
        Contact con = [
            SELECT Id, FirstName, LastName, Email, RecordTypeId, RecordType.Name
            FROM Contact 
            WHERE Id = :contactId
        ];

        // Step 5: Assert the Contact fields and Record Type
        System.assertEquals('Test', con.FirstName);
        System.assertEquals('User', con.LastName);
        System.assertEquals('testuser@gmail.com', con.Email);
        System.assertEquals(communityRt.Id, con.RecordTypeId, 'Contact must be created in Community Member Record Type');
        System.assertEquals('Community Member', con.RecordType.Name, 'Record Type name must match Community Member');
        
        
    }
}*/
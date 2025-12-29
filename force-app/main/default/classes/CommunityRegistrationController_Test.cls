@IsTest
public class CommunityRegistrationController_Test {

  /*  @testSetup
    public static void setupTestData() {
        // creating one sample record for duplicate checking
        Community_Member_Registration_Form__c reg = new Community_Member_Registration_Form__c(
            Salutation__c='Mr.',
            First_Name__c = 'Test',
            Last_Name__c = 'User',
            Email__c = 'test@gmail.com', // this email will be used to check duplicate
            Confirm_Email__c = 'test@gmail.com',
            Mobile_Number__c = '9999999999', // duplicate mobile test
            Gender__c = 'Male',
            Occupation__c = 'Salaried',
            Address_Line_1__c = 'Street 1',
            Address_Line_2__c = 'Street 2',
            State__c = 'Bihar',
            Country__c = 'India',
            City__c = 'Patna',
            Proof_of_Identity__c = 'Aadhar',
            //Zipcode__c = '800001',
            Annual_Income__c = 50000,
            Approval_Status__c = 'Pending'
        );
        insert reg;
    }


    // test method for checking missing file + duplicate checks
    @isTest
    static void testSaveRegistrationAndDuplicates() {

        System.Test.startTest();

        try {
            // here not giving file, so exception should come
           CommunityRegistrationController.saveRegistration(
                'Mr.',
                'Alice',
                'Smith',
                '8888888888',
                'alice@gmail.com',
                'alice@gmail.com',
                'Female',
                'Salaried',
                'Bihar',
                '70000',
                'India',
                'Mumbai',
                '400001',
                'PAN',
                'Street A',
                'Street B',
                'Pending',
                null // sending null file list to force error
            );

            // this should not run if exception is thrown
            System.assert(false, 'Expected exception for missing file');
        }
        catch (Exception e) {
            // ok, exception came so test case passed
            System.assert(true);
        }

        System.Test.stopTest();


        // now checking duplicate email
        System.assert(
            CommunityRegistrationController.checkDuplicateEmail('test@gmail.com'),
            'Email is already used so must be duplicate'
        );

        // unique email, so should return false
        System.assert(
            !CommunityRegistrationController.checkDuplicateEmail('unique@gmail.com'),
            'New email must not come as duplicate'
        );


        // checking duplicate mobile
        System.assert(
            CommunityRegistrationController.checkDuplicateMobile('9999999999'),
            'Mobile is already present so duplicate'
        );

        // this one does not exist
        System.assert(
            !CommunityRegistrationController.checkDuplicateMobile('2222222222'),
            'This mobile should not be duplicate'
        );
    }


    // test method for successful file upload case
    @isTest
    static void testSaveRegistrationWithFileUpload() {

        // creating test content file (dummy file)
        ContentVersion cv = new ContentVersion(
            Title = 'TestFile',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Sample file body') // some dummy blob
        );
        insert cv;

        // fetching doc id from inserted version
        Id docId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
        ].ContentDocumentId;

        // putting file id inside list because method expects list
        List<String> fileList = new List<String>{ docId };

        System.Test.startTest();

        // saving registration with file
         newRecId = CommunityRegistrationController.saveRegistration(
            'Mr.',
            'File',
            'Tester',
            '7777777777',
            'file@test.com',
            'file@test.com',
            'Female',
            'Salaried',
            'Assam',
            '50000',
            'India',
            'Chennai',
            '600001',
            'PAN',
            'Address1',
            'Address2',
            'Pending',
            fileList   // passing uploaded file ids here
        );

        System.Test.stopTest();


        // checking record created or not
        System.assertNotEquals(null, newRecId, 'Record should get created');


        // checking file linked to record
        List<ContentDocumentLink> links = [
            SELECT Id, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :newRecId
        ];

        // expecting only one link
        System.assertEquals(1, links.size(), 'One file must be linked');

        // verifying correct file
        System.assertEquals(docId, links[0].ContentDocumentId, 'File must match the uploaded one');
    }
    */
    
    
}
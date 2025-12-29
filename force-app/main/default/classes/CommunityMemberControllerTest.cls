/**
* @File Name : CommunityMemberControllerTest.cls
* @Description :This class is to test the CmmunityRegistrationController apex class
* @Author :Arthi S
* @Last Modified On : December 10, 2025

*==============================================================================

**/

@IsTest
public class CommunityMemberControllerTest {
   
    // ------------------ UTILITY: BASE64 FILE ------------------
    private static String getBase64Data() {
        Blob b = Blob.valueOf('Sample File Content');
        return EncodingUtil.base64Encode(b);
    }

    // ------------------ DUPLICATE EMAIL (Custom Object) ------------------
    @IsTest
    static void testCheckDuplicateEmail_FromRegistration() {

        insert new Community_Member_Registration_Form__c(
          	Salutation__c='Mr.',
            First_Name__c = 'Test',
            Last_Name__c = 'User',
            Email__c = 'duplicate@gmail.com',
            Confirm_Email__c = 'duplicate@gmail.com',
            Mobile_Number__c = '9999999999',
            Gender__c = 'Male',
            Occupation__c = 'Salaried',
            Address_Line_1__c = 'Addr1',
            Address_Line_2__c = 'Addr2',
            State__c = 'ASSAM',
            Country__c = 'India',
            City__c = 'BLR',
            Proof_of_Identity__c = 'Aadhar',
            Zipcode__c = 560001,
            Annual_Income__c = 50000,
            Approval_Status__c = 'Pending',
            Password__c = 'Test@123'
    
        );

        System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateEmail('duplicate@gmail.com');
        System.Test.stopTest();

        System.assertEquals(true, result);
    }

    // ------------------ DUPLICATE EMAIL (Contact) ------------------
    @IsTest
    static void testCheckDuplicateEmail_FromContact() {

        insert new Contact(
            LastName = 'ContactUser',
            Email = 'contact@gmail.com',
            Occupation__c='Salaried',
            Member_Status__c='Active',
            Password__c = 'Test@123'
        );

        System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateEmail('contact@gmail.com');
        System.Test.stopTest();

        System.assertEquals(true, result);
    }

    // ------------------ DUPLICATE MOBILE (Custom Object) ------------------
    @IsTest
    static void testCheckDuplicateMobile_FromRegistration() {

        insert new Community_Member_Registration_Form__c(
            Salutation__c='Mr.',
            First_Name__c = 'Mobile',
            Last_Name__c = 'User',
            Email__c = 'mobile@gmail.com',
            Confirm_Email__c = 'mobile@gmail.com',
            Mobile_Number__c = '8888888888',
            Gender__c = 'Male',
            Occupation__c = 'Salaried',
            Address_Line_1__c = 'Addr1',
            Address_Line_2__c = 'Addr2',
            State__c = 'ASSAM',
            Country__c = 'India',
            City__c = 'BLR',
            Proof_of_Identity__c = 'Aadhar',
            Zipcode__c = 560001,
            Annual_Income__c = 50000,
            Approval_Status__c = 'Pending',
           Password__c = 'Test@123'
        );

        System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateMobile('8888888888');
        System.Test.stopTest();

        System.assertEquals(true, result);
    }

    // ------------------ DUPLICATE MOBILE (Contact) ------------------
    @IsTest
    static void testCheckDuplicateMobile_FromContact() {

        insert new Contact(
            LastName = 'MobileContact',
            MobilePhone = '7777777777',
            Occupation__c='Salaried',
            Member_Status__c='Active',
            Password__c = 'Test@123'
        );

        System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateMobile('7777777777');
        System.Test.stopTest();

        System.assertEquals(true, result);
    }

    // ------------------ SAVE REGISTRATION + FILE SUCCESS ------------------
    @IsTest
    static void testSaveRegistrationWithFile_Success() {

        String base64Data = getBase64Data();

        System.Test.startTest();
        Id regId = CommunityRegistrationController.saveRegistrationWithFile(
            'Mr.',
            'John',
            'Doe',
            '9999999999',
            'john@gmail.com',
            'john@gmail.com',
            'Male',
            'Salaried',
            'Karnataka',
            '500000',
            'India',
            'Bengaluru',
            '560001',
            'Aadhar',
            'Address Line 1',
            'Address Line 2',
            'Pending',
            'Test@123',
            'idproof.pdf',
             base64Data,
            'application/pdf'
        );
        System.Test.stopTest();

        System.assertNotEquals(null, regId);

        // Validate File Upload
        Integer fileCount = [
            SELECT COUNT()
            FROM ContentVersion
            WHERE FirstPublishLocationId = :regId
        ];
        System.assertEquals(1, fileCount);
    }

    // ------------------ NEGATIVE: BLANK EMAIL ------------------
    @IsTest
    static void testCheckDuplicateEmail_Blank() {
       System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateEmail('');
       System.Test.stopTest();
        System.assertEquals(false, result);
    }

    // ------------------ NEGATIVE: BLANK MOBILE ------------------
    @IsTest
    static void testCheckDuplicateMobile_Blank() {
       System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateMobile('');
        System.Test.stopTest();
        System.assertEquals(false, result);
    }
}
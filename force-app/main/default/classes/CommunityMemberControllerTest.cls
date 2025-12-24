/**
* @File Name : CommunityMemberControllerTest.cls
* @Description :This class is to test the CmmunityRegistrationController apex class
* @Author :Arthi S
* @Last Modified On : December 10, 2025

*==============================================================================

**/

@IsTest
public class CommunityMemberControllerTest {

    // Utility method to create Base64 file content
    private static String getBase64Sample(Integer sizeInKB) {
        Blob b = Blob.valueOf(String.valueOf(sizeInKB));
        return EncodingUtil.base64Encode(b);
    }

    // ------------------ TEST DUPLICATE EMAIL ------------------
    @IsTest
    static void testCheckDuplicateEmail() {
        Community_Member_Registration_Form__c reg = new Community_Member_Registration_Form__c(
            Salutation__c='Mr.',
            First_Name__c = 'Test1',
            Last_Name__c = 'User',
            Email__c = 'test@gmail.com', 
            Confirm_Email__c = 'test@gmail.com',
            Mobile_Number__c = '9999999999',
            Gender__c = 'Male',
            Occupation__c = 'Salaried',
            Address_Line_1__c = 'Street 1',
            Address_Line_2__c = 'Street 2',
            State__c = 'Bihar',
            Country__c = 'India',
            City__c = 'Patna',
            Proof_of_Identity__c = 'Aadhar',
            Zipcode__c = 800001,
            Annual_Income__c = 50000,
            Approval_Status__c = 'Pending'
        );
        insert reg;

        System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateEmail('test@gmail.com');
        System.Test.stopTest();

        System.assertEquals(true, result, 'Duplicate email should return true');
    }

    // ------------------ TEST DUPLICATE MOBILE ------------------
    @IsTest
    static void testCheckDuplicateMobile() {
        Community_Member_Registration_Form__c reg = new Community_Member_Registration_Form__c(
            Salutation__c='Mr.',
            First_Name__c = 'Test2',
            Last_Name__c = 'User',
            Email__c = 'test2@gmail.com', 
            Confirm_Email__c = 'test2@gmail.com',
            Mobile_Number__c = '8888888888',
            Gender__c = 'Male',
            Occupation__c = 'Salaried',
            Address_Line_1__c = 'Street 1',
            Address_Line_2__c = 'Street 2',
            State__c = 'Bihar',
            Country__c = 'India',
            City__c = 'Patna',
            Proof_of_Identity__c = 'Aadhar',
            Zipcode__c = 800001,
            Annual_Income__c = 50000,
            Approval_Status__c = 'Pending'
        );
        insert reg;

        System.Test.startTest();
        Boolean result = CommunityRegistrationController.checkDuplicateMobile('8888888888');
        System.Test.stopTest();

        System.assertEquals(true, result, 'Duplicate mobile should return true');
    }

    // ------------------ SUCCESSFUL REGISTRATION + FILE ------------------
    @IsTest
    static void testSaveRegistrationWithFile_Success() {
        String base64Data = getBase64Sample(10); // 10 KB file

        System.Test.startTest();
        Id regId = CommunityRegistrationController.saveRegistrationWithFile(
            'Mr.', 'John', 'Doe', '9999999999', 'john@sample.com', 'john@sample.com',
            'Male', 'Salaried', 'Karnataka', '500000', 'India', 'Bengaluru', '560001',
            'Aadhar', 'Address1', 'Address2', 'Pending', 'idproof.pdf', base64Data, 'application/pdf'
        );
        System.Test.stopTest();

        System.assertNotEquals(null, regId, 'Record Id should be returned');
        System.assertEquals(1, [
            SELECT COUNT() FROM ContentVersion WHERE FirstPublishLocationId = :regId
        ]);
    
    }
}
@IsTest
private class CheckMemberStatusControllerTest {

    
    @testSetup
    static void setupTestData() {
       
        insert new Community_Member_Registration_Form__c(
            Salutation__c        = 'Mr.',
            First_Name__c        = 'Rahul',
            Last_Name__c         = 'Sharma',
            Email__c             = 'rahul.sharma@example.com',
            Confirm_Email__c     = 'rahul.sharma@example.com',
            Mobile_Number__c     = '9876543210',
            Gender__c            = 'Male',
            Occupation__c        = 'Self-Employed',
            Annual_Income__c     = 1200000,
            State__c             = 'Telangana',
            City__c              = 'Hyderabad',
            Zipcode__c           = 500081,
            Proof_of_Identity__c = 'PAN',
            Address_Line_1__c    = 'Plot No. 45, Jubilee Hills',
            Approval_Status__c   = 'Approved'
        );

        insert new Community_Member_Registration_Form__c(
            Salutation__c        = 'Ms.',
            First_Name__c        = 'Priya',
            Last_Name__c         = 'Reddy',
            Email__c             = 'priya.reddy@testmail.com',
            Confirm_Email__c     = 'priya.reddy@testmail.com',
            Mobile_Number__c     = '9123456789',
            Gender__c            = 'Female',
            Occupation__c        = 'Self-Employed',
            Annual_Income__c     = 850000,
            State__c             = 'Karnataka',
            City__c              = 'Bengaluru',
            Zipcode__c           = 560001,
            Proof_of_Identity__c = 'Aadhar',
            Address_Line_1__c    = 'MG Road, Near Metro Station',
            Approval_Status__c   = 'Rejected'
        );

        // Pending member
        insert new Community_Member_Registration_Form__c(
            Salutation__c        = 'Dr.',
            First_Name__c        = 'Test',
            Last_Name__c         = 'User',
            Email__c             = 'pending@test.com',
            Confirm_Email__c     = 'pending@test.com',
            Mobile_Number__c     = '9000000000',
            Gender__c            = 'Other',
            Occupation__c        = 'Self-Employed',
            Annual_Income__c     = 500000,
            State__c             = 'Maharashtra',
            City__c              = 'Mumbai',
            Zipcode__c           = 400001,
            Proof_of_Identity__c = 'PAN',
            Address_Line_1__c    = 'Marine Drive',
            Approval_Status__c   = 'Pending'
        );
    }

    @IsTest
    static void testEmptyEmail() {
        String result = CheckMemberStatusController.isEmailRegistered('');
        System.assertEquals('EMPTY', result, 'Blank email should return EMPTY');
    }

    @IsTest
    static void testNullEmail() {
        String result = CheckMemberStatusController.isEmailRegistered(null);
        System.assertEquals('EMPTY', result, 'Null email should return EMPTY');
    }

    @IsTest
    static void testEmailNotFound() {
        String result = CheckMemberStatusController.isEmailRegistered('notfound@test.com');
        System.assertEquals('Not_Found', result, 'Non-existing email should return Not_Found');
    }

    @IsTest
    static void testEmailFoundApproved() {
        String result = CheckMemberStatusController.isEmailRegistered('rahul.sharma@example.com');
        System.assertEquals('Approved', result, 'Should return Approved when record exists');
    }

    @IsTest
    static void testEmailFoundRejected() {
        String result = CheckMemberStatusController.isEmailRegistered('priya.reddy@testmail.com');
        System.assertEquals('Rejected', result, 'Should return Rejected when record exists');
    }

    @IsTest
    static void testEmailFoundPending() {
        String result = CheckMemberStatusController.isEmailRegistered('pending@test.com');
        System.assertEquals('Pending', result, 'Should return Pending when record exists');
    }

  @IsTest
static void testDuplicateEmailRecords() {
    // Generate two unique emails
    String email1 = 'duplicate1+' + System.currentTimeMillis() + '@test.com';
    String email2 = 'duplicate2+' + System.currentTimeMillis() + '@test.com';

    // First record
    insert new Community_Member_Registration_Form__c(
        Salutation__c        = 'Mr.',
        First_Name__c        = 'Dup1',
        Last_Name__c         = 'User',
        Email__c             = email1,
        Confirm_Email__c     = email1,
        Mobile_Number__c     = '9999999999',
        Gender__c            = 'Male',
        Occupation__c        = 'Self-Employed',
        Annual_Income__c     = 300000,
        State__c             = 'Tamil Nadu',
        City__c              = 'Chennai',
        Zipcode__c           = 600001,
        Proof_of_Identity__c = 'PAN',
        Address_Line_1__c    = 'Anna Salai',
        Approval_Status__c   = 'Approved'
    );

    insert new Community_Member_Registration_Form__c(
        Salutation__c        = 'Mrs.',
        First_Name__c        = 'Dup2',
        Last_Name__c         = 'User',
        Email__c             = email2,
        Confirm_Email__c     = email2,
        Mobile_Number__c     = '8888888888',
        Gender__c            = 'Female',
        Occupation__c        = 'Self-Employed',
        Annual_Income__c     = 1500000,
        State__c             = 'Delhi',
        City__c              = 'New Delhi',
        Zipcode__c           = 110001,
        Proof_of_Identity__c = 'PAN',
        Address_Line_1__c    = 'Connaught Place',
        Approval_Status__c   = 'Rejected'
    );

    
  
    String result1 = CheckMemberStatusController.isEmailRegistered(email1);
  
    System.assertEquals('Approved', result1, 'Should return Approved for the first record');

    String result2 = CheckMemberStatusController.isEmailRegistered(email2);
    System.assertEquals('Rejected', result2, 'Should return Rejected for the second record');
}


}
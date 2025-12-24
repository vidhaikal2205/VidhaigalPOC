/**
* @File Name : TestCommunityMemberController .cls
* @Description :This class is to get the community members who's status is pending
* @Author :Sivalingam S
* @Last Modified On : December 11, 2025

*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 11, 2025 |   | Initial Version
**/

@isTest
public class TestCommunityMemberController 
{
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
    static void testGetCommunityMembers() {
        System.Test.startTest();
        List<Community_Member_Registration_Form__c> result = CommunityMemberController.getCommunityMembers();
        System.Test.stopTest();

        System.assertNotEquals(0, result.size(), 'At least one pending record should be returned');
        System.assertEquals('Pending', result[0].Approval_Status__c, 'Only pending records should be returned');
    }

    // Test for updateStatus()
    @IsTest
    static void testUpdateStatus() {
        // Get the pending record from setup data
        Community_Member_Registration_Form__c rec = [
            SELECT Id, Approval_Status__c 
            FROM Community_Member_Registration_Form__c 
            WHERE Approval_Status__c = 'Pending' LIMIT 1
        ];

        System.Test.startTest();
        CommunityMemberController.updateStatus(rec.Id, 'Approved');
        System.Test.stopTest();

        // Query updated record
        Community_Member_Registration_Form__c updatedRec = [
            SELECT Id, Approval_Status__c 
            FROM Community_Member_Registration_Form__c 
            WHERE Id = :rec.Id
        ];

        System.assertEquals(
            'Approved',
            updatedRec.Approval_Status__c,
            'The status should be updated to Approved'
        );
    }
}
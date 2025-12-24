@isTest
public class RegistrationControllerTest {
    @testSetup
    public static void setupTestData() {
        Community_Member_Registration_Form__c reg = new Community_Member_Registration_Form__c(
            First_Name__c = 'Arthi',
            Last_Name__c = 'S',
            Email__c = '@gmail.com',
            Confirm_Email__c = 'test@gmail.com',
            Mobile_Number__c = '9999999999',
            Gender__c = 'Female',
            Occupation__c = 'Engineer',
            Address_Line_1__c = 'Street 1',
            Address_Line_2__c = 'Street 2',
            State__c = 'TN',
            Country__c = 'India',
            City__c = 'Chennai',
            Proof_of_Identity__c = 'AADHAR',
            Annual_Income__c=decimal.valueof('100000'),
            Approval_Status__c='Pending'
        );
        insert reg;
    }
    

}
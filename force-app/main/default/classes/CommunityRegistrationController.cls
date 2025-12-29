/**
* @File Name : CommunityRegistrationController.cls
* @Description :This class is to get the community members Registration details
* @Author :Arthi S
* @Last Modified On : December 11, 2025

*==============================================================================

**/

public with sharing class CommunityRegistrationController {
    
    @AuraEnabled
    
    public static Boolean checkDuplicateEmail(String email) {
        
        if (String.isBlank(email)) return false;
        
        Integer communityCount = [
            SELECT COUNT()
            FROM Community_Member_Registration_Form__c
            WHERE Email__c = :email
        ];
        
        if (communityCount > 0) return true;
        
        Integer contactCount = [
            SELECT COUNT()
            FROM Contact
            WHERE Email = :email
        ];
        
        return contactCount > 0;
    }
    
    @AuraEnabled
    public static Boolean checkDuplicateMobile(String mobileNumber) {
        
        if (String.isBlank(mobileNumber)) return false;
        
        Integer communityCount = [
            SELECT COUNT()
            FROM Community_Member_Registration_Form__c
            WHERE Mobile_Number__c = :mobileNumber
        ];
        
        if (communityCount > 0) return true;
        
        Integer contactCount = [
            SELECT COUNT()
            FROM Contact
            WHERE MobilePhone = :mobileNumber
        ];
        
        return contactCount > 0;
    }
    
    // ---------------- SAVE REGISTRATION + FILE ----------------
    @AuraEnabled
    public static Id saveRegistrationWithFile(
        String salutation,
        String firstName,
        String lastName,
        String mobileNumber,
        String email,
        String confirmEmail,
        String gender,
        String occupation,
        String state,
        String annualIncome,
        String country,
        String city,
        String zipcode,
        String proofOfIdentity,
        String addressLine1,
        String addressLine2,
        String approvalStatus,
        String password,
        String fileName,
        String base64Data,
        String contentType
    ){
        
        if (checkDuplicateEmail(email)) {
            throw new AuraHandledException('EMAIL_DUPLICATE');
        }
        
        if (checkDuplicateMobile(mobileNumber)) {
            throw new AuraHandledException('MOBILE_DUPLICATE');
        }
        
        
        if (String.isBlank(fileName) || String.isBlank(base64Data)) {
            throw new AuraHandledException('ID Proof upload is mandatory.');
        }
        // Normalize jpeg → jpg (Salesforce-safe workaround)
        if (fileName.toLowerCase().endsWith('.jpeg')) {
            fileName = fileName.replaceAll('(?i)\\.jpeg$', '.jpg');
        }
        
        // Allow only safe extensions
        String lowerName = fileName.toLowerCase();
        if (
            !lowerName.endsWith('.pdf') &&
            !lowerName.endsWith('.jpg') &&
            !lowerName.endsWith('.png')
        ) {
            throw new AuraHandledException(
                'Only PDF, JPG, JPEG, and PNG files are allowed.'
            );
        }
        
        Integer MAX_SIZE = 5 * 1024 * 1024; // 5MB
        Blob fileBlob = EncodingUtil.base64Decode(base64Data);
        
        if (fileBlob.size() > MAX_SIZE) {
            throw new AuraHandledException(fileName + ' exceeds the 5MB file size limit.');
        }
        
        // --- Create Registration Record ---
        
        Community_Member_Registration_Form__c reg = new Community_Member_Registration_Form__c();
        try{
            reg.Salutation__c = salutation;
            reg.First_Name__c = firstName;
            reg.Last_Name__c = lastName;
            reg.Mobile_Number__c = mobileNumber;
            reg.Email__c = email;
            reg.Confirm_Email__c = confirmEmail;
            reg.Gender__c = gender;
            reg.Occupation__c = occupation;
            reg.State__c = state;
            if (!String.isBlank(annualIncome)) {
                reg.Annual_Income__c = Decimal.valueOf(annualIncome.trim());
            }
            
            //reg.Annual_Income__c = Decimal.valueOf(annualIncome);
            reg.Country__c = country;
            reg.City__c = city;
            
            
            reg.Zipcode__c = Integer.valueOf(zipcode);
            
            reg.Proof_of_Identity__c = proofOfIdentity;
            reg.Address_Line_1__c = addressLine1;
            reg.Address_Line_2__c = addressLine2;
            reg.Approval_Status__c = approvalStatus;
            reg.Password__c= password;
            
            insert reg;
        } catch (Exception e) {
            System.debug('ERROR: ' + e.getMessage());
            throw new AuraHandledException('Registration failed: ' + e.getMessage());
        }
        
        // --- Save File ---
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = fileBlob;
        cv.FirstPublishLocationId = reg.Id; // Link to registration record
        insert cv;
        
        return reg.Id;
    }
}
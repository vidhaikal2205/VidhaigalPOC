/**
* @File Name : IdPreviewController .cls
* @Description :This class is to get the Id of the file uploaded in the record
* @Author :Sivalingam S
* @Last Modified On : December 20, 2025

*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 20, 2025 |   | Initial Version
**/

@IsTest
public class IdPreviewControllerTest {

    @IsTest
    static void testGetFileDetails() {

        
        Account acc = new Account(Name = 'Test Account');
        insert acc;

       
        ContentVersion cv = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test file content'),
            IsMajorVersion = true
        );
        insert cv;

        
        ContentVersion insertedCV = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
        ];

       
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = insertedCV.ContentDocumentId,
            LinkedEntityId = acc.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert cdl;

        
        system.Test.startTest();
        Map<String, String> result =
            IdPreviewController.getFileDetails(acc.Id);
        system.Test.stopTest();

        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.containsKey('versionId'), 'VersionId key missing');
        System.assert(result.containsKey('fileType'), 'FileType key missing');
        System.assertNotEquals(null, result.get('versionId'), 'VersionId should not be null');
        System.assertNotEquals(null, result.get('fileType'), 'FileType should not be null');
    }
}
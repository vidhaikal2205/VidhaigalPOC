/**
* @File Name : IdPreviewController .cls
* @Description :This class is to get the Id of the file uploaded in the record
* @Author :Sivalingam S
* @Last Modified On : December 18, 2025

*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 17, 2025 |   | Initial Version
**/

public class IdPreviewController 
{
    @AuraEnabled(cacheable=true)
    public static string getFileDetails(Id recordId)
    {
         ContentDocumentLink cdl = [
            SELECT ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
            LIMIT 1
        ];

        return cdl.ContentDocument.LatestPublishedVersionId;
    }
}
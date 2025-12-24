/**
* @File Name : IdPreviewController .cls
* @Description :This class is to get the Id of the file uploaded in the record
* @Author :Sivalingam S
* @Last Modified On : December 20, 2025

*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 17, 2025 |   | Initial Version
**/


public with sharing class IdPreviewController {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getFileDetails(Id recordId) {

        ContentDocumentLink cdl = [
            SELECT ContentDocument.LatestPublishedVersionId,
                   ContentDocument.FileType
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
            LIMIT 1
        ];

        Map<String, String> result = new Map<String, String>();
        result.put('versionId', cdl.ContentDocument.LatestPublishedVersionId);
        result.put('fileType', cdl.ContentDocument.FileType);

        return result;
    }
}


/*public class IdPreviewController 
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
}*/
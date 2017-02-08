public with sharing class ImageController {
/*
----------------------------------------------------------------------
-- - Author        : SharinPix
-- - Description   :
-- Maintenance History:
--
-- Date         Name  Version  Remarks
-- -----------  ----  -------  ---------------------------------------
-- 25-OCT-2016  LBO    1.0      Initial version
----------------------------------------------------------------------
**********************************************************************
*/
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = new Attachment();
        a.parentId = parentId;
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        insert a;
        return a.Id;
    }
    
    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        if (fileId == null) {
            boolean isCreateable = Crud.isCreateable(parentId.getSObjectType());
            if (!isCreateable  || !Crud.isCreateable(Attachment.sObjectType)){
                throw new AuraHandledException(system.label.Err_insufficient_privileges);
            }
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            if (!(Crud.isAccessible(parentId.getSObjectType()) && Crud.isUpdateable(parentId.getSObjectType()))){
                throw new AuraHandledException(system.label.Err_insufficient_privileges);
            }
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }

    @AuraEnabled
    public static object getFiles(Id parentId, String prefix, String contentType) { 
        String nameLike = prefix + '%';
        boolean isAccessible = Crud.isAccessible(parentId.getSObjectType());
        if (!isAccessible){
            throw new AuraHandledException(system.label.Err_insufficient_privileges);
            return null;
        }
        list<map<string, Id>> lstImages = new list<map<string, Id>>();
        for(Attachment att: [SELECT ID 
                            FROM Attachment 
                            WHERE ParentId = :parentId 
                            AND ContentType LIKE :contentType 
                            AND Name LIKE :nameLike 
                            ORDER BY CreatedDate 
                            DESC LIMIT 50]){
            lstImages.add(new map<string, Id>{'Id'=> att.Id});
        }
        set<id> setContentId = new set<id>();
        set<string> filetype = new set<string>{'jpg', 'jpeg', 'png', 'gif'};
        for(ContentDocumentLink content: [SELECT ContentDocumentId, 
                                                ContentDocument.FileType 
                                         FROM ContentDocumentLink 
                                         WHERE LinkedEntityId = :parentId
                                         AND ContentDocument.FileType IN :filetype]){
            setContentId.add(content.ContentDocumentId);
        }
        for(ContentVersion version: [SELECT ContentDocumentId, 
                                            Id 
                                    FROM ContentVersion 
                                    WHERE ContentDocumentId IN :setContentId
                                    AND IsLatest = true]){
            lstImages.add(new map<string, Id>{'Id'=> version.Id});
        }
        return lstImages;
    }
    
    @AuraEnabled
    public static Boolean deleteAttachment(Id Id){
        Schema.sObjectType sobjectType = Id.getSobjectType();
        string objectname = sObjectType.getDescribe().getName();
        boolean isDeletable = false;
        if (objectname == 'Attachment') {
            isDeletable = Crud.isDeletable(Attachment.sObjectType);
            list<Attachment> lstAttachment = [SELECT Id, Parentid FROM Attachment WHERE Id = :id];
            if(lstAttachment.isEmpty()){
                throw new AuraHandledException(system.label.Err_insufficient_privileges);
            }
            if (!Crud.isDeletable(lstAttachment[0].ParentId.getSObjectType())){
                throw new AuraHandledException(system.label.Err_insufficient_privileges);
            }
            delete lstAttachment;
        }
        else if (objectname == 'ContentVersion') {
            isDeletable = (Crud.isDeletable(ContentDocument.sobjecttype));
            list<ContentDocument> lstContentDocument =  [SELECT Id 
                                                        FROM ContentDocument 
                                                        WHERE Id = :[SELECT ContentDocumentId 
                                                                    FROM ContentVersion 
                                                                    WHERE Id = :Id].ContentDocumentId];
            if(lstContentDocument.isEmpty() || !isDeletable){
                throw new AuraHandledException(system.label.Err_insufficient_privileges);
            }
            delete lstContentDocument;
        }
        
        return true;
    }

    private static void appendToFile(Id fileId, String base64Data) {
        Attachment a = new Attachment(Id=fileId);
        a.Body = EncodingUtil.base64Decode(EncodingUtil.base64Encode([Select Body From Attachment Where Id = :fileId].body) + EncodingUtil.urlDecode(base64Data, 'UTF-8')); 
        update a;
    }

    @AuraEnabled
    public static string site(){
        return Site.getBaseUrl();
    }
}
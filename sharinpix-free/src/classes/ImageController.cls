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
    public static list<Attachment> getFiles(Id parentId, String prefix, String contentType) { 
        String nameLike = prefix + '%';
        List<Schema.SObjectField> fieldslstCRUD = new List<Schema.SObjectField>{Attachment.Fields.Id, Attachment.Fields.ParentId, Attachment.Fields.Name, Attachment.Field.CreatedDate};
        boolean isAccessible = Crud.isAccessible(parentId.getSObjectType());
        if (!isAccessible){
            throw new AuraHandledException(system.label.Err_insufficient_privileges);
            return null;
        }
        return [SELECT ID FROM Attachment WHERE ParentId = :parentId AND ContentType LIKE :contentType AND Name LIKE :nameLike ORDER BY CreatedDate DESC LIMIT 50];
    }
    
    @AuraEnabled
    public static Boolean deleteAttachment(Id Id){
        boolean isDeletable = Crud.isDeletable(Attachment.sObjectType);
        list<Attachment> lstAttachment = [SELECT Id, Parentid FROM Attachment WHERE Id = :id];
        if(lstAttachment.isEmpty()){
            //throw new AuraHandledException(system.label.Err_insufficient_privileges);
            return true;
        }
        if (!Crud.isDeletable(lstAttachment[0].ParentId.getSObjectType())){
            throw new AuraHandledException(system.label.Err_insufficient_privileges);
        }
        delete lstAttachment;
        return true;    
    }

    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = :fileId
        ];

        String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        
        update a;
    }
}
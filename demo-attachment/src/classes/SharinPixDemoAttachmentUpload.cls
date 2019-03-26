public class SharinPixDemoAttachmentUpload {

    public static void uploadAttachment(list<Attachment> attachmentList, set<id> emailMsgIdSet){
        map<Id, Id> caseIdMap = new map<Id, Id>();
        for(EmailMessage email: [select id, parentId from EmailMessage where Id in :emailMsgIdSet]){
            caseIdMap.put(email.id, email.parentId);
        }

        for(Attachment att: attachmentList){
            upload_photo(att.id, caseIdMap.get(att.parentId));
        }
    }

    @future (callout=true)
    public static void upload_photo(Id attachmentId, string caseId){
        SharinPix.Utils utilsInstance = SharinPix.Utils.getInstance();
        if (utilsInstance!=null){
            utilsInstance.uploadAttachment(attachmentId, caseId);
        }
        else {
            system.debug('### Error occurred');
        }
    }
}
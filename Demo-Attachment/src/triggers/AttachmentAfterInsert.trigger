trigger AttachmentAfterInsert on Attachment (after insert) {

    list<Attachment> attachmentList = new list<Attachment>();
    set<id> emailMsgIdSet = new set<id>();

    for(Attachment att: trigger.new){
        if (string.valueof(att.parentId).startsWith('02s') && att.contentType == 'image/jpeg'){
            attachmentList.add(att);
            emailMsgIdSet.add(att.parentId);
        }
    }

    if (!attachmentList.isEmpty()){
        AP01_UploadToSharinPix.uploadAttachment(attachmentList, emailMsgIdSet);
    }
}

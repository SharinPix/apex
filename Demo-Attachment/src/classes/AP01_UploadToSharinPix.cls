public class AP01_UploadToSharinPix {
	
    public static void uploadAttachment(list<Attachment> attachmentList, set<id> emailMsgIdSet){
    	map<Id, Id> caseIdMap = new map<Id, Id>();
    	for(EmailMessage email: [select id, parentId from EmailMessage where Id in :emailMsgIdSet]){
    		caseIdMap.put(email.id, email.parentId);
    	}//end for  

    	for(Attachment att: attachmentList){
    		upload_photo(att.id, caseIdMap.get(att.parentId));
    	}
    } 

    @future (callout=true)
    public static void upload_photo(string attachmentId, string caseId){ 
        SharinPix.Client clientInstance = SharinPix.Client.getInstance();
        if (clientInstance!=null){
            clientInstance.upload_attachment(attachmentId, caseId);
        }
        else {
            system.debug('### Error occurred');
        }
    }
}
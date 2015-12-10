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
        list<Credential__c> credential = Credential__c.getAll().values();
        if (!credential.isEmpty()){
            string client_id = credential[0].Client_Id__c;
            string client_secret = credential[0].Client_Secret__c;
            Client clientInstance = new Client(client_id, client_secret, Client.API_URL);
            clientInstance.upload_image_to_album(attachmentId, caseId);
        }
        else {
            system.debug('### Error occurred');
        }
    }
}
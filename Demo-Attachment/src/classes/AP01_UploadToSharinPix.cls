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
    	string client_id = 'a06d99e4-2772-4bff-a243-749b28fa6e24';
        string client_secret = 'dfd13c53da6e2768808e2f7b6109e833';
        Client clientInstance = new Client(client_id, client_secret, Client.API_URL);
        
        clientInstance.upload_image_to_album(attachmentId, caseId);
    }
    
}
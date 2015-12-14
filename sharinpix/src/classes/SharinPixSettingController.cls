public with sharing class SharinPixSettingController {
	public Credential__c credential {get;set;}
	public SharinPixSettingController() {
		credential = Credential__c.getOrgDefaults();
		if (string.isblank(credential.Endpoint_Url__c)){
			credential.Endpoint_Url__c = 'https://api.sharinpix.com/api/v1';
		}
	}

	public pagereference saveCredential() {
		if (string.isblank(credential.Client_Id__c) || string.isblank(credential.Client_Secret__c)){
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.ClientInformationMissing));	
		}
		else {
			upsert credential;
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, system.label.CredentialSuccess));
		}
		return null;
	}

	public PageReference testApi() {
		Client instance = new Client(credential.Client_Id__c, credential.Client_Secret__c, credential.Endpoint_Url__c);
		try {
			Map<String, Object> response = instance.api_get('/organization', new map<String, object>());
			if(response.containsKey('id')){
				upsert credential;
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.label.ApiTestSuccess));
			}
			else {
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.ApiTestFailure));	
			}
		}
		catch(Exception e){
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.ApiTestFailure));
		}
		return null;
	}
}
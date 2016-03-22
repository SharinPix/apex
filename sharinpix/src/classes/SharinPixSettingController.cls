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
            Client instance = new Client(credential.Client_Id__c, credential.Client_Secret__c, credential.Endpoint_Url__c);

            boolean test = instance.test_api();
            if (test){
                upsert credential;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, system.label.CredentialSuccess));
            }
            else {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.ApiTestFailure));
            }
        }
        return null;
    }
}
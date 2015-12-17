@isTest
private class SharinPixSettingControllerTEST {

    static string API_URL = 'https://api.sharinpix.test/api/v1';

    static testMethod void testSaveCredentialFailure(){
        SharinPixSettingController controller = new SharinPixSettingController();
        controller.credential.Client_Id__c = '';
        controller.credential.Client_Secret__c = 'test-secret';

        test.startTest();
        controller.saveCredential();
        test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains(system.label.ClientInformationMissing)) b = true;
        }
        system.assert(b);
    }

    static testMethod void testApiSuccess(){
        SharinPixSettingController controller = new SharinPixSettingController();
        controller.credential.Client_Id__c = 'test-id';
        controller.credential.Client_Secret__c = 'test-secret';
        controller.credential.Endpoint_Url__c = API_URL;

        SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/organization', firstResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        controller.saveCredential();
        test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains(system.label.CredentialSuccess)) b = true;
        }
        system.assert(b);

        Credential__c credential = Credential__c.getOrgDefaults();
        system.assertEquals(credential.Client_Id__c, 'test-id');
        system.assertEquals(credential.Client_Secret__c, 'test-secret');
    }

    static testMethod void testApiFailure1(){
        SharinPixSettingController controller = new SharinPixSettingController();
        controller.credential.Client_Id__c = 'test-id';
        controller.credential.Client_Secret__c = 'test-secret';
        controller.credential.Endpoint_Url__c = API_URL;

        SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/organization', firstResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        controller.saveCredential();
        test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains(system.label.ApiTestFailure)) b = true;
        }
        system.assert(b);
    }
}

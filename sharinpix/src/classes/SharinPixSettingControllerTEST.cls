@isTest
private class SharinPixSettingControllerTEST {
  static final String API_URL = 'https://api.sharinpix.com/api/v1';

  static testMethod void testParameters() {
    Map<String, Object> params = new Map<String, Object> { 'admin' => true, 'path' => '/admin' };
    Test.startTest();
    SharinPixSettingController ctrl = new SharinPixSettingController();
    Test.stopTest();
    System.assertEquals(JSON.serialize(params), ctrl.parameters);
  }

  static testMethod void testSecretIsValid() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String, HttpCalloutMock>();
    mapRequestResponse.put(API_URL + '/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    SharinPixSettingController.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1');
    Test.startTest();
    System.assert(SharinPixSettingController.hasValidSecret());
    Test.stopTest();
  }

  static testMethod void testSecretIsInvalidated() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String, HttpCalloutMock>();
    mapRequestResponse.put(API_URL + '/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    SharinPixSettingController.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1');

    firstResponse = new SingleRequestMock(401, 'Unauthorized', '', null);
    mapRequestResponse = new Map<String,HttpCalloutMock>();
    mapRequestResponse.put(API_URL + '/organization', firstResponse);
    multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    System.assert(!SharinPixSettingController.hasValidSecret());
    Test.stopTest();
  }

  static testMethod void testSaveSecretWithValidUrl() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String,HttpCalloutMock>();
    mapRequestResponse.put(API_URL + '/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    System.assert(SharinPixSettingController.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1'));
    Test.stopTest();
  }

  static testMethod void testSaveSecretWithMalformedUrl() {
    Test.startTest();
    System.assert(!SharinPixSettingController.saveSecret('http://notsharin.pix'));
    Test.stopTest();
  }

  static testMethod void testOrgInfos() {
    String expected = JSON.serialize([SELECT Id, InstanceName, IsSandbox, Name, OrganizationType FROM Organization LIMIT 1]);
    Test.startTest();
    System.assertEquals(expected, SharinPixSettingController.getOrgInfos());
    Test.stopTest();
  }
}
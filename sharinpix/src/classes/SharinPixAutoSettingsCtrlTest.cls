@isTest
private class SharinPixAutoSettingsCtrlTest {
  static testMethod void testParameters() {
    Map<String, Object> params = new Map<String, Object>();
    params.put('admin', true);
    params.put('path', '/admin');
    Test.startTest();
    SharinPixAutoSettingsCtrl ctrl = new SharinPixAutoSettingsCtrl();
    Test.stopTest();
    System.assertEquals(JSON.serialize(params), ctrl.parameters);
  }

  static testMethod void testSecretIsAbsent() {
    Test.startTest();
    System.assertEquals('ABSENT', SharinPixAutoSettingsCtrl.isSecretValid());
    Test.stopTest();
  }

  static testMethod void testSecretIsValid() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String, HttpCalloutMock>();
    mapRequestResponse.put('https://api.sharinpix.com/api/v1/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    SharinPixAutoSettingsCtrl.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1');
    Test.startTest();
	System.assertEquals('VALID', SharinPixAutoSettingsCtrl.isSecretValid());
    Test.stopTest();
  }

  static testMethod void testSecretIsInvalidated() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String, HttpCalloutMock>();
    mapRequestResponse.put('https://api.sharinpix.com/api/v1/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    SharinPixAutoSettingsCtrl.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1');

    firstResponse = new SingleRequestMock(401, 'Unauthorized', '', null);
    mapRequestResponse = new Map<String,HttpCalloutMock>();
    mapRequestResponse.put('https://api.sharinpix.com/api/v1/organization', firstResponse);
    multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    System.assertEquals('INVALID', SharinPixAutoSettingsCtrl.isSecretValid());
    Test.stopTest();
  }

  static testMethod void testSaveSecretWithValidUrl() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{"id":"c4a87f6a-677e-4c2c-bf14-8496e8edf5e2", "name":"SharinPix"}', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String,HttpCalloutMock>();
    mapRequestResponse.put('https://api.sharinpix.com/api/v1/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    System.assert(SharinPixAutoSettingsCtrl.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1'));
    Test.stopTest();
  }

  static testMethod void testSaveSecretWithInvalidUrl() {
    SingleRequestMock firstResponse = new SingleRequestMock(401, 'Unauthorized', '', null);
    Map<String, HttpCalloutMock> mapRequestResponse = new Map<String, HttpCalloutMock>();
    mapRequestResponse.put('https://api.sharinpix.com/api/v1/organization', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapRequestResponse);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    System.assert(!SharinPixAutoSettingsCtrl.saveSecret('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1'));
    Test.stopTest();
  }

  static testMethod void testSaveSecretWithMalformedUrl() {
    Test.startTest();
    System.assert(!SharinPixAutoSettingsCtrl.saveSecret('http://notsharin.pix'));
    Test.stopTest();
  }
}
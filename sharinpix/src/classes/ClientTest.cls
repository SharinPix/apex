@isTest
public with sharing class ClientTest {
  static Attachment att1;
  static Case case1;
  static String API_URL = 'https://api.sharinpix.com/api/v1';

  static {
    case1 = new Case(Status='New', Origin='Email');
    insert case1;
    att1 = new Attachment(Name='Image.jpg', ContentType='image/jpeg', Body=Blob.valueof('This is an image'), ParentId=case1.Id);
  }

  static testMethod void testMock() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{}', null);
    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
    endpoint2TestResp.put(API_URL+'/imports/', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    insert att1;
    Test.startTest();
    Client clientInstance = Client.getInstance();
    String ret = clientInstance.upload_attachment_to_album(att1.Id, case1.id);
    Test.stopTest();

    System.assertEquals(ret, '');
  }

  static testMethod void testMock2() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok', '{}', null);
    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
    endpoint2TestResp.put(API_URL+'/imports/', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    String encodedBody = EncodingUtil.base64Encode(att1.body);
    if (encodedBody.endsWith('=')){
      encodedBody = encodedBody.substring(0, encodedBody.length()-3);
    }
    att1.body = EncodingUtil.base64Decode(encodedBody);
    insert att1;

    Test.startTest();
    Client clientInstance = Client.getInstance();
    String ret = clientInstance.upload_attachment_to_album(att1.Id, case1.id);
    Test.stopTest();

    System.assertEquals(ret, '');
  }

  static testMethod void testClientInstance() {
    Test.startTest();
    Client clientInstance = Client.getInstance();
    Test.stoptest();

    System.assertEquals(clientInstance.client_id, 'test');
    System.assertEquals(clientInstance.client_secret, 'test');
    System.assertEquals(clientInstance.endpoint_url, API_URL);
  }

  static testMethod void testNewClient() {
    Test.startTest();
    Client clientInstance = new Client('clientid', 'clientsecret', 'https://api.sharinpix.com/api/v1');
    Test.stopTest();
    System.assertEquals('clientid', clientInstance.client_id);
    System.assertEquals('clientsecret', clientInstance.client_secret);
    System.assertEquals(API_URL, clientInstance.endpoint_url);
  }

  static testMethod void testNewClientFromValidURL() {
    Test.startTest();
    Client clientInstance = new Client('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1');
    Test.stopTest();
    System.assertEquals('clientid', clientInstance.client_id);
    System.assertEquals('clientsecret', clientInstance.client_secret);
    System.assertEquals(API_URL, clientInstance.endpoint_url);
  }

  static testMethod void testNewClientFromInvalidURL() {
    try {
      Test.startTest();
      Client clientIns = new Client('sharinpix://clientcredential@api.sharinpix.com/api/v1');
      Test.stopTest();
      System.assert(false);
    } catch (Exception e) {
      System.assertEquals('Invalid SharinPix URL', e.getMessage());
    }
  }

  static testMethod void testDeprecatedDeleteTagImage() {
    Client clientInstance = Client.getInstance();

    Test.startTest();
    String ret = clientInstance.delete_tag_image('a', 'b');
    Test.stopTest();

    System.assertEquals(ret, null);
  }

  static testMethod void testDeprecatedAddtagImage() {
    Client clientInstance = Client.getInstance();

    Test.startTest();
    String ret = clientInstance.add_tag_image('a', 'b');
    Test.stopTest();

    System.assertEquals(ret, null);
  }

  static testMethod void testApiGet() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"public_id":"99d11f10-8b55-493d-9314-333e68bc8f5c"}', null);
    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
    endpoint2TestResp.put(API_URL+'/albums', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    Client clientInstance = Client.getInstance();
    Map<string, object> ret = clientInstance.api_get('/albums', new Map<String, Object>());
    Test.stopTest();

    System.assertEquals(String.valueOf(ret.get('public_id')), '99d11f10-8b55-493d-9314-333e68bc8f5c');
  }

  static testMethod void testApiPost() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"public_id":"99d11f10-8b55-493d-9314-333e68bc8f5c"}', null);
    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
    endpoint2TestResp.put(API_URL+'/albums', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    Client clientInstance = Client.getInstance();
    Map<String, Object> ret = clientInstance.api_post('/albums', Blob.valueOf('this is a test'), new Map<String, Object>());
    Test.stopTest();

    System.assertEquals(String.valueOf(ret.get('public_id')), '99d11f10-8b55-493d-9314-333e68bc8f5c');
  }

  static testMethod void testApiPut() {
    SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"images_count": "0", "public_id": "sharinpix2", "thumbnails": "", "upload_form": "", "views_count": "0"}', null);
    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
    endpoint2TestResp.put(API_URL+'/albums/sharinpix', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    Client clientInstance = Client.getInstance();
    Map<String, Object> ret = (Map<String, Object>) clientInstance.put('/albums/sharinpix', Blob.valueOf('this is a test'), new Map<String, Object>());
    Test.stopTest();

    System.assertEquals(String.valueOf(ret.get('public_id')), 'sharinpix2');
  }

  static testMethod void testApiDelete() {
    SingleRequestMock firstResponse = new SingleRequestMock(204, 'No cntent','{}',null);
    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
    endpoint2TestResp.put(API_URL+'/albums', firstResponse);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    Client clientInstance = Client.getInstance();
    Map<String, Object> ret = clientInstance.api_delete('/albums', new Map<String, Object>());
    Test.stopTest();

    System.assertEquals(ret, null);
  }

  static testMethod void testTestApiSuccess() {
    Client clientInstance = Client.getInstance();

    Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
      API_URL + '/organization' => new SingleRequestMock(200, 'OK', '{"id":"orgId"}', null)
    };
    Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

    Test.startTest();
    Boolean isValid = clientInstance.test_api();
    Test.stopTest();

    System.assert(isValid);
  }

  static testMethod void testTestApiFailure() {
    Client clientInstance = Client.getInstance();

    Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
      API_URL + '/organization' => new SingleRequestMock(404, 'Not Found', '', null)
    };
    Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

    Test.startTest();
    Boolean isValid = clientInstance.test_api();
    Test.stopTest();

    System.assert(!isValid);
  }

  static testMethod void testPermanentToken() {
    Map<String, Object> params = new Map<String, Object> { 'exp' => 0 };
    Client clientInstance = Client.getInstance();
    Test.startTest();
    String token = clientInstance.token(params);
    Test.stopTest();
    String base64Payload = token.substring(token.indexOf('.') + 1, token.lastIndexOf('.'));
    Map<String, Object> tokenPayload = (Map<String, Object>)JSON.deserializeUntyped(EncodingUtil.base64Decode(base64Payload).toString());
    System.assertEquals(null, tokenPayload.get('exp'));
  }

  static testMethod void testTokenWithExpSet() {
    Map<String, Object> params = new Map<String, Object> { 'exp' => (Datetime.now().getTime()/1000 + 1) + 500 };
    Client clientInstance = Client.getInstance();
    Test.startTest();
    String token = clientInstance.token(params);
    Test.stopTest();
    String base64Payload = token.substring(token.indexOf('.') + 1, token.lastIndexOf('.'));
    Map<String, Object> tokenPayload = (Map<String, Object>)JSON.deserializeUntyped(EncodingUtil.base64Decode(base64Payload).toString());
    System.assertEquals(500, (Integer)tokenPayload.get('exp') - (Integer)tokenPayload.get('iat'));
  }

  static testMethod void testTokenWithNoExpSet() {
    Map<String, Object> params = new Map<String, Object> { 'key' => 'value' };
    Client clientInstance = Client.getInstance();
    Test.startTest();
    String token = clientInstance.token(params);
    Test.stopTest();
    String base64Payload = token.substring(token.indexOf('.') + 1, token.lastIndexOf('.'));
    Map<String, Object> tokenPayload = (Map<String, Object>)JSON.deserializeUntyped(EncodingUtil.base64Decode(base64Payload).toString());
    System.assertEquals(300, (Integer)tokenPayload.get('exp') - (Integer)tokenPayload.get('iat'));
  }

  static testMethod void coverageForDeprecatedUnused() {
    Client clientInstance = Client.getInstance();
    Test.startTest();
    System.assertEquals(null, clientInstance.getTagsOnImage('albumId', 'imageId', null));
    System.assertEquals(false, clientInstance.removeTag('albumId', 'imageId', null));
    System.assertEquals(null, clientInstance.addTag('albumId', 'imageId', 'tagName'));
    System.assertEquals(null, clientInstance.getImageDetails('albumId', 'imageId'));
    System.assertEquals(null, clientInstance.croppedImageUrl('imageId', 'cropStyle', 0, 0));
    System.assertEquals(null, clientInstance.getAlbumImages('albumId'));
    System.assertEquals(null, clientInstance.getImageUrl('imageId', null, null));
    Test.stopTest();
  }
}
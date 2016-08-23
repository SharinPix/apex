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

  static testMethod void testAddTagImage() {
    Client clientInstance = Client.getInstance();

    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
    SingleRequestMock res = new SingleRequestMock(200, 'Ok','{"test": "test"}',null);
    endpoint2TestResp.put(API_URL+'/tags/tagName/tag_images', res);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Test.startTest();
    Map<String, Object> ret = (Map<String, Object>) clientInstance.add_tag_image('albumId', 'imageId', 'tagName');
    Test.stopTest();

    System.assertEquals(String.valueof(ret.get('test')), 'test');
  }

  static testMethod void testClearTagImage() {
    String imageId = 'imageId';
    String albumId = 'albumId';
    Client clientInstance = Client.getInstance();

    Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
    SingleRequestMock first = new SingleRequestMock(200, 'Ok','[{"id": "test"}]',null);
    SingleRequestMock second = new SingleRequestMock(204, 'No content','{"test": "test"}',null);
    endpoint2TestResp.put(API_URL+'/tag_images?image_id='+imageId, first);
    endpoint2TestResp.put(API_URL+'/tag_images/test', second);
    HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
    Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    Boolean ret = false;
    Test.startTest();
    ret = clientInstance.clear_tag_image(albumId, imageId, new List<String> {'tag'});
    Test.stopTest();

    System.assert(ret);
  }

  static testMethod void testClientInstance() {
    Test.startTest();
    Client clientInstance = Client.getInstance();
    Test.stoptest();

    System.assertEquals(clientInstance.client_id, 'test');
    System.assertEquals(clientInstance.client_secret, 'test');
    System.assertEquals(clientInstance.endpoint_url, 'https://api.sharinpix.com/api/v1');
  }

  static testMethod void testNewClientFromValidURL() {
    Client clientInstance = new Client('sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1');
    System.assertEquals('clientid', clientInstance.client_id);
    System.assertEquals('clientsecret', clientInstance.client_secret);
    System.assertEquals('https://api.sharinpix.com/api/v1', clientInstance.endpoint_url);
  }

  static testMethod void testNewClientFromInvalidURL() {
    try {
      Client clientIns = new Client('sharinpix://clientcredential@api.sharinpix.com/api/v1');
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
}

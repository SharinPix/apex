@IsTest
public with sharing class ClientTest {
    static Attachment att1;
    static Case case1;
    static string API_URL = 'https://api.sharinpix.test/api/v1';

    static {
        case1 = new Case(Status='New', Origin='Email');
        insert case1;
        att1 = new Attachment(Name='Image.jpg', ContentType='image/jpeg', Body=Blob.valueof('This is an image'), ParentId=case1.Id);
    }

    static testMethod void testMock(){
        SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"public_id":"99d11f10-8b55-493d-9314-333e68bc8f5c","upload_form":{"url":"https://api.cloudinary.com/v1_1/hwja6b0dx/auto/upload","params":{"timestamp":1449051274,"transformation":"a_exif","callback":"https://localhost/cloudinary_cors.html","type":"private","tags":"99d11f10-8b55-493d-9314-333e68bc8f5c","signature":"794baa26c36e0f6f35dae498c5313670ed8f45c5","api_key":"744524991939777"}},"images_count":1,"views_count":0,"thumbnails":[{"public_id":"58738212-d891-4931-a0e4-895a917d1b28","infos":{"bytes":3604,"created_at":"2015-09-25T13:32:55Z","etag":"5a98d4d3e5d39024abf237be55e99b15","format":"png","height":48,"resource_type":"image","tags":["99d11f10-8b55-493d-9314-333e68bc8f5c"],"type":"private","width":48,"location":{"accuracy":36,"latitude":48.861934399999996,"longitude":2.348967}},"exifs":{},"gps":[48.861934399999996,2.348967],"gps_ip":null,"gps_exifs":null,"gps_html":[48.861934399999996,2.348967],"created_at":"2015-12-02T11:14:34.269+01:00","width":48,"height":48,"rotation":0,"crop_x":0.0,"crop_y":0.0,"crop_w":0.0,"crop_h":0.0,"album_id":"99d11f10-8b55-493d-9314-333e68bc8f5c","thumbnails":{"full":"/assets/blank.jpg","large":"/assets/blank.jpg","mini":"/assets/blank.jpg"}}]}',null);
        SingleRequestMock secondResponse = new SingleRequestMock(200, 'Ok','{"public_id":"y1tbrymtuozqiaocrm2n","version":1449663204,"signature":"cf72619efe8f3a335ffca296b1ba89229244ec82","width":510,"height":330,"format":"jpg","resource_type":"image","created_at":"2015-12-09T12:13:24Z","tags":["50024000005Ii2QAAS"],"bytes":87785,"type":"private","etag":"16c6dabff69949b0bde2a58560a21c77","url":"http://res.cloudinary.com/hwdbenbwd/image/private/s--Zwg5gua6--/v1449663204/y1tbrymtuozqiaocrm2n.jpg","secure_url":"https://res.cloudinary.com/hwdbenbwd/image/private/s--Zwg5gua6--/v1449663204/y1tbrymtuozqiaocrm2n.jpg","original_filename":"raphael_teenage_mutant_ninja_turtles-t2"}',null);
        SingleRequestMock thirdResponse = new SingleRequestMock(200, 'Ok','{"images": "uploaded"}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/albums/'+case1.Id, firstResponse);
        endpoint2TestResp.put('https://api.cloudinary.com/v1_1/hwja6b0dx/auto/upload', secondResponse);
        endpoint2TestResp.put(API_URL+'/albums/'+case1.Id+'/images', thirdResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        insert att1;
        test.startTest();
        string client_id = 'test';
        string client_secret = 'test';
        Client clientInstance = new Client(client_id, client_secret, API_URL);
        clientInstance.upload_attachment_to_album(att1.Id, case1.id);
        test.stopTest();
    }

    static testMethod void testMock2(){
        SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"public_id":"99d11f10-8b55-493d-9314-333e68bc8f5c","upload_form":{"url":"https://api.cloudinary.com/v1_1/hwja6b0dx/auto/upload","params":{"timestamp":1449051274,"transformation":"a_exif","callback":"https://localhost/cloudinary_cors.html","type":"private","tags":"99d11f10-8b55-493d-9314-333e68bc8f5c","signature":"794baa26c36e0f6f35dae498c5313670ed8f45c5","api_key":"744524991939777"}},"images_count":1,"views_count":0,"thumbnails":[{"public_id":"58738212-d891-4931-a0e4-895a917d1b28","infos":{"bytes":3604,"created_at":"2015-09-25T13:32:55Z","etag":"5a98d4d3e5d39024abf237be55e99b15","format":"png","height":48,"resource_type":"image","tags":["99d11f10-8b55-493d-9314-333e68bc8f5c"],"type":"private","width":48,"location":{"accuracy":36,"latitude":48.861934399999996,"longitude":2.348967}},"exifs":{},"gps":[48.861934399999996,2.348967],"gps_ip":null,"gps_exifs":null,"gps_html":[48.861934399999996,2.348967],"created_at":"2015-12-02T11:14:34.269+01:00","width":48,"height":48,"rotation":0,"crop_x":0.0,"crop_y":0.0,"crop_w":0.0,"crop_h":0.0,"album_id":"99d11f10-8b55-493d-9314-333e68bc8f5c","thumbnails":{"full":"/assets/blank.jpg","large":"/assets/blank.jpg","mini":"/assets/blank.jpg"}}]}',null);
        SingleRequestMock secondResponse = new SingleRequestMock(200, 'Ok','{"public_id":"y1tbrymtuozqiaocrm2n","version":1449663204,"signature":"cf72619efe8f3a335ffca296b1ba89229244ec82","width":510,"height":330,"format":"jpg","resource_type":"image","created_at":"2015-12-09T12:13:24Z","tags":["50024000005Ii2QAAS"],"bytes":87785,"type":"private","etag":"16c6dabff69949b0bde2a58560a21c77","url":"http://res.cloudinary.com/hwdbenbwd/image/private/s--Zwg5gua6--/v1449663204/y1tbrymtuozqiaocrm2n.jpg","secure_url":"https://res.cloudinary.com/hwdbenbwd/image/private/s--Zwg5gua6--/v1449663204/y1tbrymtuozqiaocrm2n.jpg","original_filename":"raphael_teenage_mutant_ninja_turtles-t2"}',null);
        SingleRequestMock thirdResponse = new SingleRequestMock(200, 'Ok','{"images": "uploaded"}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/albums/'+case1.Id, firstResponse);
        endpoint2TestResp.put('https://api.cloudinary.com/v1_1/hwja6b0dx/auto/upload', secondResponse);
        endpoint2TestResp.put(API_URL+'/albums/'+case1.Id+'/images', thirdResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        string encodedBody = EncodingUtil.base64Encode(att1.body);
        if (encodedBody.endsWith('=')){
            system.debug('#### '+encodedBody);
            encodedBody = encodedBody.substring(0, encodedBody.length()-3);
        }
        att1.body = EncodingUtil.base64Decode(encodedBody);
        insert att1;

        test.startTest();
        string client_id = 'test';
        string client_secret = 'test';
        Client clientInstance = new Client(client_id, client_secret, API_URL);
        clientInstance.upload_attachment_to_album(att1.Id, case1.id);
        test.stopTest();
    }

    static testMethod void testAddTagImage(){
        string client_id = 'test';
        string client_secret = 'test';
        Client clientInstance = new Client(client_id, client_secret, API_URL);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        SingleRequestMock res = new SingleRequestMock(200, 'Ok','{"test": "test"}',null);
        endpoint2TestResp.put(API_URL+'/tags/tagName/tag_images', res);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        clientInstance.add_tag_image('albumId', 'imageId', 'tagName');
        test.stopTest();
    }

    static testMethod void testClearTagImage(){
        string client_id = 'test';
        string client_secret = 'test';
        string imageId = 'imageId';
        string albumId = 'albumId';

        Client clientInstance = new Client(client_id, client_secret, API_URL);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        SingleRequestMock first = new SingleRequestMock(200, 'Ok','[{"id": "test"}]',null);
        SingleRequestMock second = new SingleRequestMock(204, 'No content','{"test": "test"}',null);
        endpoint2TestResp.put(API_URL+'/tag_images?image_id='+imageId, first);
        endpoint2TestResp.put(API_URL+'/tag_images/test', second);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        clientInstance.clear_tag_image(albumId, imageId, new list<string>{'tag'});
        test.stopTest();
    }

    static testMethod void testClientInstance(){
        Credential__c credential = new Credential__c(Client_Id__c='test', Client_Secret__c='test', Endpoint_Url__c='https://api.sahrinpix.test/api/v1');
        insert credential;

        Client clientins ;
        test.startTest();
        clientins = Client.getInstance();
        test.stoptest();
    }

    static testMethod void testDeprecatedDeleteTagImage(){

        string client_id = 'test';
        string client_secret = 'test';

        Client clientInstance = new Client(client_id, client_secret, API_URL);

        test.startTest();
        clientInstance.delete_tag_image('a', 'b');
        test.stopTest();
    }

    static testMethod void testDeprecatedAddtagImage(){

        string client_id = 'test';
        string client_secret = 'test';

        Client clientInstance = new Client(client_id, client_secret, API_URL);

        test.startTest();
        clientInstance.add_tag_image('a', 'b');
        test.stopTest();
    }

    static testMethod void testApiGet(){
        SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"public_id":"99d11f10-8b55-493d-9314-333e68bc8f5c"}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/albums', firstResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        string client_id = 'test';
        string client_secret = 'test';
        Client clientInstance = new Client(client_id, client_secret, API_URL);
        clientInstance.api_get('/albums', new map<string, object>());
        test.stopTest();
    }

    static testMethod void testApiPost(){
        SingleRequestMock firstResponse = new SingleRequestMock(200, 'Ok','{"public_id":"99d11f10-8b55-493d-9314-333e68bc8f5c"}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/albums', firstResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        string client_id = 'test';
        string client_secret = 'test';
        Client clientInstance = new Client(client_id, client_secret, API_URL);
        clientInstance.api_post('/albums', Blob.valueof('this is a test'), new map<string, object>());
        test.stopTest();
    }

    static testMethod void testApiDelete(){
        SingleRequestMock firstResponse = new SingleRequestMock(204, 'No cntent','{}',null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(API_URL+'/albums', firstResponse);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();
        string client_id = 'test';
        string client_secret = 'test';
        Client clientInstance = new Client(client_id, client_secret, API_URL);
        clientInstance.api_delete('/albums', new map<string, object>());
        test.stopTest();
    }
}

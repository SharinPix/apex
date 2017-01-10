@isTest
private with sharing class UtilsTest {

    static Case case1;
    static String API_URL = 'https://api.sharinpix.com/api/v1';

    static {
        case1 = new Case(Status='New', Origin='Email');
        insert case1;
    }

    static testMethod void testRenameAlbum() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
          API_URL + '/albums/oldAlbumId' => new SingleRequestMock(200, 'OK', '{"public_id":"newAlbumId"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Boolean renamed = (new Utils()).renameAlbum('oldAlbumId', 'newAlbumId');
        Test.stopTest();

        System.assert(renamed);
    }

    static testMethod void testGetAlbumImages() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/albums/' + case1.Id + '/images?page=1' => new SingleRequestMock(200, 'OK', '[{"public_id":"imageId"}]', null),
            API_URL + '/albums/' + case1.Id + '/images?page=2' => new SingleRequestMock(200, 'OK', '[]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        List<Object> images = (new Utils()).getAlbumImages(case1.Id);
        Test.stoptest();

        System.assertEquals('imageId', ((Map<String, Object>)images[0]).get('public_id'));
    }

    static testMethod void testGetImageDetails() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/images/imageId' => new SingleRequestMock(200, 'OK', '{"albumId":"albumId","imageId":"imageId"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Map<String, Object> response = (new Utils()).getImageDetails('albumId', 'imageId');
        Test.stopTest();

        System.assertEquals('imageId', response.get('imageId'));
    }

    static testMethod void testGetImageUrl() {
        Test.setMock(
            HttpCalloutMock.class,
            new SingleRequestMock(200, 'OK', '', new Map<String, String> { 'Location' => 'https://test.cloudinary.com/imageId' })
        );

        Test.startTest();
        String imageUrl = (new Utils()).getImageUrl(
        'imageId',
            new Map<String, Object> { 'download' => false },
            new List<Object> { new Map<String, Object> { 'crop' => 'fit', 'width' => 500 } }
        );
        Test.stopTest();

        System.assertEquals('https://test.cloudinary.com/imageId', imageUrl);
    }

    static testMethod void testCroppedImageUrl() {
        Utils sharinpixUtils = new Utils();
        String albumId = 'albumId', imageId = 'imageId';
        String cropErrorMessage, sizeErrorMessage;

        Test.setMock(
            HttpCalloutMock.class,
            new SingleRequestMock(200, 'OK', '', new Map<String, String> { 'Location' => 'https://test.cloudinary.com/imageId' })
        );

        Test.startTest();
        String transformedImageUrl = sharinpixUtils.croppedImageUrl(imageId, 'fit', 200, 200);
        try {
            sharinpixUtils.croppedImageUrl(albumId, 'plop', 200, 200);
        } catch (Exception e) {
            cropErrorMessage = e.getMessage();
        }
        try {
            sharinpixUtils.croppedImageUrl(albumId, 'fit', 0, 0);
        } catch (Exception e) {
            sizeErrorMessage = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals('https://test.cloudinary.com/imageId', transformedImageUrl);
        System.assertEquals('Invalid crop style.', cropErrorMessage);
        System.assertEquals('Invalid width or height.', sizeErrorMessage);
    }

    static testMethod void testGetTagsOnImage() {
        String albumId = 'albumId', imageId = 'imageId';

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tag_images?album_id=' + albumId + '&image_id=' + imageId + '&page=1' => new SingleRequestMock(200, 'OK','[{"tag":{"name":"name"}}]', null),
            API_URL + '/tag_images?album_id=' + albumId + '&image_id=' + imageId + '&page=2' => new SingleRequestMock(200, 'OK','[]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        List<String> response = (List<String>)(new Utils()).getTagsOnImage('albumId', 'imageId', new List<String> { 'tagName' });
        Test.stopTest();

        System.assertEquals(response[0], 'name');
    }

    static testMethod void testAddTag() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tags/tagName/tag_images' => new SingleRequestMock(200, 'OK','{"test":"test"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Map<String, Object> response = (Map<String, Object>)(new Utils()).addTag('albumId', 'imageId', 'tagName');
        Test.stopTest();

        System.assertEquals(String.valueof(response.get('test')), 'test');
    }

    static testMethod void testRemoveTags() {
        String albumId = 'albumId', imageId = 'imageId';

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tag_images?image_id=' + imageId => new SingleRequestMock(200, 'OK', '[{"id":"test"}]', null),
            API_URL + '/tag_images/test' => new SingleRequestMock(204, 'No Content', '{"test":"test"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Boolean tagRemoved = false;
        Test.startTest();
        tagRemoved = (new Utils()).removeTags(albumId, imageId, new List<String> { 'tag' });
        Test.stopTest();

        System.assert(tagRemoved);
    }

}
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
        Boolean renamed = (new Utils(Client.getInstance())).renameAlbum('oldAlbumId', 'newAlbumId');
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
        Map<String, Object> response = (new Utils()).getImageDetails('imageId');
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
        String imageId = 'imageId';
        String cropErrorMessage, sizeErrorMessage;

        Test.setMock(
            HttpCalloutMock.class,
            new SingleRequestMock(200, 'OK', '', new Map<String, String> { 'Location' => 'https://test.cloudinary.com/imageId' })
        );

        Test.startTest();
        String transformedImageUrl = sharinpixUtils.croppedImageUrl(imageId, 'fit', 200, 200);
        try {
            sharinpixUtils.croppedImageUrl(imageId, 'plop', 200, 200);
        } catch (Exception e) {
            cropErrorMessage = e.getMessage();
        }
        try {
            sharinpixUtils.croppedImageUrl(imageId, 'fit', 0, 0);
        } catch (Exception e) {
            sizeErrorMessage = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals('https://test.cloudinary.com/imageId', transformedImageUrl);
        System.assertEquals('Invalid crop style.', cropErrorMessage);
        System.assertEquals('Invalid width or height.', sizeErrorMessage);
    }

    static testMethod void testGetImageExternalUrl() {
        Map<String, Object> image = new Map<String, Object> {
            'image_id' => 'imageId',
            'sharinpix' => new Map<String, Object> {
                'download' => false
            },
            'transformations' => new Map<String, Object> {
                'crop' => 'fit',
                'height' => 300,
                'width' => 300
            }
        };

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/image_external_urls' => new SingleRequestMock(200, 'OK','{"image_id":"imageId","url":"https://cloudinary.url"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Map<String, Object> imageObj = (new Utils()).getImageExternalUrl(image);
        Test.stopTest();

        System.assertEquals('imageId', (String)imageObj.get('image_id'));
        System.assertEquals('https://cloudinary.url', (String)imageObj.get('url'));
    }

    static testMethod void testGetExternalImageUrls() {
        List<Map<String, Object>> images = new List<Map<String, Object>> {
            new Map<String, Object> {
                'image_id' => 'imageId',
                'sharinpix' => new Map<String, Object> {
                    'download' => false
                },
                'transformations' => new Map<String, Object> {
                    'crop' => 'fit',
                    'height' => 300,
                    'width' => 300
                }
            }
        };

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/image_external_urls' => new SingleRequestMock(200, 'OK','{"image_id":"imageId","url":"https://cloudinary.url"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        List<Object> response = (List<Object>)(new Utils()).getImageExternalUrls(images);
        Test.stopTest();

        Map<String, Object> imageObj = (Map<String, Object>)response[0];
        System.assertEquals('imageId', (String)imageObj.get('image_id'));
        System.assertEquals('https://cloudinary.url', (String)imageObj.get('url'));
    }

    static testMethod void testGetExternalImageUrls2() {
        List<Map<String, Object>> images = new List<Map<String, Object>> {
            new Map<String, Object> {
                'image_id' => 'imageId',
                'sharinpix' => new Map<String, Object> {
                    'download' => false
                },
                'transformations' => new Map<String, Object> {
                    'crop' => 'fit',
                    'height' => 300,
                    'width' => 300
                }
            },
            new Map<String, Object> {
                'image_id' => 'imageId',
                'sharinpix' => new Map<String, Object> {
                    'download' => false
                },
                'transformations' => new Map<String, Object> {
                    'crop' => 'fit',
                    'height' => 300,
                    'width' => 300
                }
            }
        };

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/image_external_urls' => new SingleRequestMock(200, 'OK','[{"image_id":"imageId","url":"https://cloudinary.url"},{"image_id":"imageId","url":"https://cloudinary.url"}]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        List<Object> response = (List<Object>)(new Utils()).getImageExternalUrls(images);
        Test.stopTest();

        Map<String, Object> imageObj = (Map<String, Object>)response[0];
        System.assertEquals('imageId', (String)imageObj.get('image_id'));
        System.assertEquals('https://cloudinary.url', (String)imageObj.get('url'));

        imageObj = (Map<String, Object>)response[1];
        System.assertEquals('imageId', (String)imageObj.get('image_id'));
        System.assertEquals('https://cloudinary.url', (String)imageObj.get('url'));
    }

    static testMethod void testGetAlbumTagImages() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tag_images?album_id=albumId&tag_name=tagName&page=1' => new SingleRequestMock(200, 'OK','[{"tag":{"name":"tagName"}}]', null),
            API_URL + '/tag_images?album_id=albumId&tag_name=tagName&page=2' => new SingleRequestMock(200, 'OK','[]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        List<Object> tagImages = (new Utils()).getAlbumTagImages('albumId', 'tagName');
        Test.stopTest();

        Map<String, Object> tagImage = (Map<String, Object>)tagImages[0];
        String tagName = (String)((Map<String, Object>)tagImage.get('tag')).get('name');

        System.assertEquals('tagName', tagName);
    }

    static testMethod void testGetTagNamesOnImage() {
        String imageId = 'imageId';

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tag_images?image_id=' + imageId + '&page=1' => new SingleRequestMock(200, 'OK','[{"tag":{"name":"name"}}]', null),
            API_URL + '/tag_images?image_id=' + imageId + '&page=2' => new SingleRequestMock(200, 'OK','[]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        List<String> response = (List<String>)(new Utils()).getTagNamesOnImage('imageId');
        Test.stopTest();

        System.assertEquals(response[0], 'name');
    }

    static testMethod void testAddTag() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tags/tagName/tag_images' => new SingleRequestMock(200, 'OK','{"test":"test"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Map<String, Object> response = (Map<String, Object>)(new Utils()).addTag('imageId', 'tagName');
        Test.stopTest();

        System.assertEquals(String.valueOf(response.get('test')), 'test');
    }

    static testMethod void testRemoveTags() {
        String imageId = 'imageId';

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tag_images?image_id=' + imageId + '&page=1' => new SingleRequestMock(200, 'OK','[{"id":"tagImageId","tag":{"name":"name"}}]', null),
            API_URL + '/tag_images?image_id=' + imageId + '&page=2' => new SingleRequestMock(200, 'OK','[]', null),
            API_URL + '/tag_images/tagImageId' => new SingleRequestMock(204, 'No Content', '{"test":"test"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Boolean tagRemoved = false;
        Test.startTest();
        tagRemoved = (new Utils()).removeTags(imageId, new List<String> { 'name' });
        Test.stopTest();

        System.assert(tagRemoved);
    }

    static testMethod void testClearTags() {
        String imageId = 'imageId';

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/tag_images?image_id=' + imageId + '&page=1' => new SingleRequestMock(200, 'OK','[{"id":"tagImageId","tag":{"name":"name"}}]', null),
            API_URL + '/tag_images?image_id=' + imageId + '&page=2' => new SingleRequestMock(200, 'OK','[]', null),
            API_URL + '/tag_images/tagImageId' => new SingleRequestMock(204, 'No Content', '{"test":"test"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Boolean tagRemoved = false;
        Test.startTest();
        tagRemoved = (new Utils()).clearTags(imageId);
        Test.stopTest();

        System.assert(tagRemoved);
    }

    static testMethod void testUploadAttachment() {
        Case cs = new Case(Status='New', Origin='Email');
        insert cs;
        Attachment att = new Attachment(Name='Image.jpg', ContentType='image/jpeg', Body=Blob.valueof('This is an image'), ParentId=cs.Id);
        insert att;

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/imports/' => new SingleRequestMock(200, 'OK', '{}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Object response = (new Utils()).uploadAttachment(att.Id, cs.Id);
        Test.stopTest();

        System.assertEquals(JSON.serialize(response), '{}');
    }

    static testMethod void testUploadFromUrl() {
        Case cs = new Case(Status='New', Origin='Email');
        insert cs;
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/imports/' => new SingleRequestMock(200, 'OK', '{}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        Object response = (new Utils()).uploadFromUrl('http://lorempixel.com/1000/1000', cs.Id, 'lorempixel.jpg');
        Test.stopTest();

        System.assertEquals(JSON.serialize(response), '{}');
    }

    //static testMethod void testGenerateMobileAppUrl() {
    //    String albumId = 'TestId';
    //    String name = 'TestName';
    //    String optionsJson = '{\'grayscale\':true}';
    //    Map<String, Object> options = Utils.parseJsonParam(optionsJson);

    //    Test.startTest();
    //    String appurl = (new Utils()).generateMobileAppUrl(albumId, name, options, 300);
    //    Test.stopTest();

    //    System.assert(appUrl.contains('native_upload'));
    //    String token = appUrl.substringAfter('token=');
    //    String[] tokenParts = token.split('\\.');
    //    String decodedData = EncodingUtil.base64Decode(tokenParts[1]).toString();
    //    System.assert(decodedData.contains('TestId'));
    //    System.assert(decodedData.contains('TestName'));
    //    System.assert(decodedData.contains('{"grayscale":true}'));
    //}
}
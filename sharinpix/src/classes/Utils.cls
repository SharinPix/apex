global with sharing class Utils {

    private Client clientInstance = null;

    /**
     * Get Utils instance with default Client ID and secret
     * @return Utils instance
     */
    global Utils() {
        this.clientInstance = Client.getInstance();
    }

    /**
     * Get Utils instance with specific Client ID and secret
     * @param  clientInstance Instance of sharinpix.Client
     * @return   Utils instance
     */
    global Utils(Client instance) {
        this.clientInstance = instance;
    }

    /**
     * Renames an album
     * @param oldAlbumId ID of the album to be renamed
     * @param newAlbumId ID to give the album
     * @return           true if album is successfully renamed
     */
    global Boolean renameAlbum(String oldAlbumId, String newAlbumId) {
        Map<String, Object> album = (Map<String, Object>)clientInstance.put(
            '/albums/' + oldAlbumId,
            Blob.valueOf(
                JSON.serialize(
                    new Map<String, Object> {
                        'album' => new Map<String, String> {
                            'public_id' => newAlbumId
                        }
                    }
                )
            ),
            new Map<String, Object> {
                'abilities' => new Map<String, Object> {
                    oldAlbumId => new Map<String, Object> {
                        'Access'  => new Map<String, Object> {
                                'see' => true,
                                'rename' => true
                        }
                    }
                }
            }
        );
        return newAlbumId == (String)album.get('public_id');
    }

    /**
     * Get all images from an album. Cast image object as Map<String, Object> to access attributes
     * @param albumId ID of the album to retrieve images for
     * @return        List of image objects
     */
    global List<Object> getAlbumImages(String albumId) {
        if (albumId InstanceOf Id) {
            albumId = (Id)albumId;
        }
        Map<String, Object> albumParams = new Map<String, Object> {
            'Id' => albumId,
            'abilities' => new Map<String, Object> {
                albumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_list' => true
                    }
                }
            }
        };
        List<Object> albumImages = new List<Object>();
        List<Object> pageImages;
        Integer page = 1;
        do {
            pageImages = (List<Object>)clientInstance.get('/albums/' + albumId + '/images?page=' + page++, albumParams);
            albumImages.addAll(pageImages);
        } while (pageImages.size() != 0);
        return albumImages;
    }

    /**
     * Get image details
     * @param imageId Public ID of image to fetch details on
     * @return        Map containing image details
     */
    global Map<String, Object> getImageDetails(String imageId) {
        Object imageObj = clientInstance.get(
            '/images/' + imageId,
            new Map<String, Object> { 'admin' => true }
        );
        return (Map<String, Object>)imageObj;
    }

    /**
     * Get URL of transformed image
     * @param  imageId         Public ID of image to transform
     * @param  sharinpix       SharinPix transformations
     * @param  transformations Image transformations
     * @return                 URL of transformed image
     */
    global String getImageUrl(String imageId, Map<String, Object> sharinpix, List<Object> transformations) {
        if (sharinpix == null) sharinpix = new Map<String, Object>();
        if (transformations == null) transformations = new List<Object>();
        Map<String, Object> params = new Map<String, Object> {
            'id' => imageId,
            'sharinpix' => sharinpix,
            'transformations' => transformations
        };
        HTTPRequest request = new HTTPRequest();
        request.setMethod('GET');
        request.setEndpoint(clientInstance.getUrl() + '/images/' + imageId + '?token=' + clientInstance.token(params));
        HTTPResponse response = (new HTTP()).send(request);
        return response.getHeader('Location');
    }

    /**
     * Crops or resizes an image
     * @param imageId   Public ID of image to crop
     * @param cropStyle Crop style to apply. Possible values: fill, fit, scale, pad, crop, thumb
     * @param width     Width to resize to, 0 if only height is to be used
     * @param height    Height to resize to, 0 if only width is to be used
     * @return          URL of transformed image
     */
    global String croppedImageUrl(String imageId, String cropStyle, Integer width, Integer height) {
        Matcher patternMatcher = Pattern.compile('fill|fit|scale|pad|crop|thumb').matcher(cropStyle);
        if (!patternMatcher.matches()) {
            throw new SharinPixException('Invalid crop style.');
        }
        if ((width == null && height == null) || (width == 0 && height == 0) || width < 0 || height < 0) {
            throw new SharinPixException('Invalid width or height.');
        }
        Map<String, Object> transfomation = new Map<String, Object> { 'crop' => cropStyle };
        if (width != 0) {
            transfomation.put('width', width);
        }
        if (height != 0) {
            transfomation.put('height', height);
        }
        return this.getImageUrl(imageId, new Map<String, Object>(), new List<Object> { transfomation });
    }

    private Object externalUrlPost(Object body) {
        Blob blobBody = Blob.valueOf(JSON.serialize(body));
        Map<String, Object> params = new Map<String, Object> { 'admin' => true };
        return clientInstance.post('/image_external_urls', blobBody, params);
    }

    /**
     * Apply transformations on image and get external url
     * @param  images List of Map objects specifying image_id, sharinpix options and transformations
     * @return        List of Map objects containing 'image_id' and 'url' as keys
     */
    global Map<String, Object> getExternalImageUrl(Map<String, Object> imageTransformation) {
        Map<String, Object> body = new Map<String, Object> {
            'image_external_url' => imageTransformation
        };
        return (Map<String, Object>)externalUrlPost(body);
    }

    /**
     * Apply transformations on images and get external image urls
     * @param  images List of Map objects specifying image_id, sharinpix options and transformations
     * @return        List of Map objects containing 'image_id' and 'url' as keys
     */
    global List<Object> getExternalImageUrls(List<Map<String, Object>> imageTransformations) {
        Map<String, Object> body = new Map<String, Object> {
            'image_external_urls' => imageTransformations
        };
        return (List<Object>)externalUrlPost(body);
    }

    /**
     * Retrieve all TagImages from an album with a specified tagName
     * @param  albumId albumId to get tag images from
     * @param  tagName name of tag to get images with
     * @return         List of tags on image
     */
    global List<Object> getAlbumTagImages(String albumId, String tagName) {
        albumId = (albumId InstanceOf Id) ? String.valueOf((Id)albumId) : albumId;
        Map<String, Object> params = new Map<String, Object> { 'admin' => true };
        Integer page = 1;
        List<Object> tagImagesPage = new List<Object>();
        List<Object> allTagImages = new List<Object>();
        do {
            tagImagesPage = (List<Object>)clientInstance.get(
                '/tag_images?album_id=' + albumId +
                '&tag_name=' + clientInstance.urlEncode(tagName) +
                '&page=' + page++
            , params);
            allTagImages.addAll(tagImagesPage);
        } while (tagImagesPage.size() != 0);
        return allTagImages;
    }

    /**
     * Retrieves all tags from an image
     * @param  imageId Image ID of image to get tags for
     * @return         List of tags on image
     */
    global List<Object> getTagsOnImage(String imageId) {
        Map<String, Object> params = new Map<String, Object> { 'admin' => true };
        Integer page = 1;
        List<Object> tagImagesPage = new List<Object>();
        List<Object> allTagImages = new List<Object>();
        do {
            tagImagesPage = (List<Object>)clientInstance.get('/tag_images?image_id=' + imageId + '&page=' + page++, params);
            allTagImages.addAll(tagImagesPage);
        } while (tagImagesPage.size() != 0);
        return allTagImages;
    }

    /**
     * Retrieves all tag names from an image
     * @param  imageId Image ID of image to get tags for
     * @return         List of tag names on image
     */
    global List<String> getTagNamesOnImage(String imageId) {
        List<Object> allTagImages = getTagsOnImage(imageId);
        List<String> tagsOnImage = new List<String>();
        for (Object tagImage : allTagImages) {
            tagsOnImage.add((String)((Map<String, Object>)((Map<String, Object>)tagImage).get('tag')).get('name'));
        }
        return tagsOnImage;
    }

    /**
     * Add a tag to an image
     * @param  imageId Public ID of the image to tag
     * @param  tagName Name of tag to add to image
     * @return         Map containing the newly created tag image details
     */
    global Object addTag(String imageId, String tagName) {
        Map<String, Object> claims = new Map<String, Object> { 'admin' => true };
        return clientInstance.post(
            '/tags/' + clientInstance.urlEncode(tagName) + '/tag_images',
            Blob.valueOf('{"image_ids":["' + imageId + '"]}'),
            claims
        );
    }

    /**
     * Removes tags from a tagged image
     * @param  imageId Public ID of the image to untag
     * @param  tags    List of tags to remove from image
     * @return         true if tags removed, false otherwise
     */
    global Boolean removeTags(String imageId, String[] tags) {
        try {
            List<Object> tagImages = this.getTagsOnImage(imageId);
            for (Object tagImage : tagImages) {
                for (String tag : tags) {
                    if ( ((String)(((Map<String, Object>)((Map<String, Object>)tagImage).get('tag')).get('name'))).equals(tag) ) {
                        clientInstance.destroy(
                            '/tag_images/' + (String)((Map<String, Object>)tagImage).get('id'),
                            new Map<String, Object> { 'admin' => true }
                        );
                    }
                }
            }
            return true;
        } catch (Exception e) {
            throw new SharinPixException(e.getCause() + '[' + e.getLineNumber() + ']: ' + e.getMessage());
        }
    }

    /**
     * Clears an image of all its tags
     * @param  imageId The ID of the image to clear tags from
     * @return         true if all tags cleared, otherwise an exception is thrown
     */
    global Boolean clearTags(String imageId) {
        try {
            List<Object> tagImages = this.getTagsOnImage(imageId);
            for (Object tagImage : tagImages) {
                clientInstance.destroy(
                    '/tag_images/' + (String)((Map<String, Object>)tagImage).get('id'),
                    new Map<String, Object> { 'admin' => true }
                );
            }
            return true;
        } catch (Exception e) {
            throw new SharinPixException(e.getCause() + '[' + e.getLineNumber() + ']: ' + e.getMessage());
        }
    }

    /**
     * Uploads Salesforce Attachments to SharinPix albums
     * @param  attachmentId Salesforce Attachment ID
     * @param  albumId      SharinPix album ID to upload to
     * @return              Object containing reply from SharinPix
     */
    global Object uploadAttachment(Id attachmentId, String albumId) {
        Map<String, Object> metadatas = new Map<String, Object>();
        return this.uploadAttachment(attachmentId, albumId, metadatas);
    }

    /**
     * Uploads Salesforce Attachments to SharinPix albums
     * @param  attachmentId Salesforce Attachment ID
     * @param  albumId      SharinPix album ID to upload to
     * @param  metadatas    Attachment metadata map
     * @return              Object containing reply from SharinPix
     */
    global Object uploadAttachment(Id attachmentId, String albumId, Map<String, Object> metadatas) {
        if (!(Schema.sObjectType.Attachment.isAccessible()
                && Schema.sObjectType.Attachment.fields.Id.isAccessible()
                && Schema.sObjectType.Attachment.fields.Name.isAccessible()
                && Schema.sObjectType.Attachment.fields.Body.isAccessible())) {
            throw new SharinPixException('Insufficient privileges.');
        }
        Attachment attachment = [SELECT Id, Name FROM Attachment WHERE Id = :attachmentId LIMIT 1];

        Map<String, Object> claims = new Map<String, Object> {
            'abilities' => new Map<String, Object> {
                albumId => new Map<String, Object> {
                    'Access' => new Map<String, Object> {
                        'see' => true,
                        'image_upload' => true
                    }
                }
            }
        };

        if (!metadatas.containsKey('attachmentId')) {
            metadatas.put('attachmentId', attachmentId);
        }

        Map<String, Object> importPayload = new Map<String, Object> {
            'filename' => attachment.Name,
            'metadatas' => metadatas,
            'album_id' => albumId,
            'attachment_id' => attachmentId,
            'import_type' => 'salesforce'
        };

        return clientInstance.post('/imports/', Blob.valueOf(JSON.serialize(importPayload)), claims);
    }

}
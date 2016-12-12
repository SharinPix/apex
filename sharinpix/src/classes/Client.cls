global with sharing class Client {
  private static Client instance = null;

  private static final String API_URL = 'https://api.sharinpix.com';

  global String client_id { get; set; }
  global String client_secret { get; set; }
  global String endpoint_url { get; set; }

  global static Client getInstance() {
    if (Test.isRunningTest()) {
      return instance = new Client('sharinpix://test:test@api.sharinpix.com/api/v1');
    }
    Credential__c cr = Credential__c.getOrgDefaults();
    if (instance == null) {
      if (String.isNotBlank(cr.SharinPix_URL__c)) {
        instance = new Client(cr.SharinPix_URL__c);
      } else {
        instance = new Client(cr.Client_Id__c, cr.Client_Secret__c, cr.Endpoint_Url__c);
      }
    }
    return instance;
  }

  global Client(String client_id, String client_secret, String endpoint_url) {
    this.client_id = client_id;
    this.client_secret = client_secret;
    this.endpoint_url = endpoint_url;
  }

  global Client(String sharinpixUrl) {
    try {
      String clientId = sharinpixUrl.substring(sharinpixUrl.indexOf('/') + 2, sharinpixUrl.indexOf(':', 10));
      String clientSecret = sharinpixUrl.substring(sharinpixUrl.indexOf(':', 10) + 1, sharinpixUrl.indexOf('@'));
      String endpointUrl = 'https://' + sharinpixUrl.substring(sharinpixUrl.indexOf('@') + 1);
      if (String.isNotBlank(clientId) && String.isNotBlank(clientSecret) && String.isNotBlank(endpointUrl)) {
        this.client_id = clientId;
        this.client_secret = clientSecret;
        this.endpoint_url = endpointUrl;
      }
    } catch (Exception e) {
      throw new SharinPixException('Invalid SharinPix URL');
    }
  }

  /**
   * Renames an album
   * @param oldAlbumId ID of the album to be renamed
   * @param newAlbumId ID to give the album
   * @return           true if album is successfully renamed
   */
  global Boolean renameAlbum(String oldAlbumId, String newAlbumId) {
    Map<String, Object> album = (Map<String, Object>)this.put(
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
   * Performs a POST request on a SharinPix endpoint
   * @param  endpoint The endpoint to POST to
   * @param  body     The body of the request
   * @param  claims   The parameters to generate the auth token with
   * @return          The object returned from the POST request
   */
  global Object post(String endpoint, Blob body, Map<String, Object> claims) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('POST');
    req.setHeader('Authorization', 'Token token="' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    req.setBodyAsBlob(body);
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatus() == 'OK') {
      return JSON.deserializeUntyped(response.getBody());
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': ' + response.getBody());
    }
  }

  /**
   * Performs a PUT request on a SharinPix endpoint
   * @param  endpoint The endpoint to PUT into
   * @param  body     The body of the request
   * @param  claims   The parameters to generate the auth token with
   * @return          The object returned from the PUT request
   */
  global Object put(String endpoint, Blob body, Map<String, Object> claims) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('PUT');
    req.setHeader('Authorization', 'Token token="' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    req.setBodyAsBlob(body);
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatus() == 'OK') {
      return JSON.deserializeUntyped(response.getBody());
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': ' + response.getBody());
    }
  }

  /**
   * Performs a GET request on a SharinPix endpoint
   * @param  endpoint The endpoint to GET from
   * @param  claims   The parameters to generate the auth token with
   * @return          The object returned from the GET request
   */
  global Object get(String endpoint, Map<String, Object> claims) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('GET');
    req.setHeader('Authorization', 'Token token="' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatus() == 'OK') {
      return JSON.deserializeUntyped(response.getBody());
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': ' + response.getBody());
    }
  }

  /**
   * Performs a DELETE request on a SharinPix endpoint
   * @param  endpoint The endpoint to DELETE from
   * @param  claims   The parameters to generate the auth token with
   * @return          true if the DELETE is successful, false otherwise
   */
  global Boolean destroy(String endpoint, Map<String, Object> claims) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('DELETE');
    req.setHeader('Authorization', 'Token token=\"' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatusCode() == 204) {
      return true;
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
    }
  }

  global Object upload_attachment(id attachmentId, string albumId, Map<String, Object> metadatas) {
    if (!(Schema.sObjectType.Attachment.isAccessible()
          && Schema.sObjectType.Attachment.fields.Id.isAccessible()
          && Schema.sObjectType.Attachment.fields.Name.isAccessible()
          && Schema.sObjectType.Attachment.fields.Body.isAccessible())) {
      throw new SharinPixException('Insufficient privilege');
    }
    Attachment attachment = [SELECT Id, Name FROM Attachment WHERE Id=:attachmentId LIMIT 1];

    Map<String, Object> album_access = new Map<String, Object>();
    album_access.put('see', true);
    album_access.put('image_upload', true);
    Map<String, Object> album_ability = new Map<String, Object>();
    album_ability.put('Access', album_access);
    Map<String, Object> abilities = new Map<String, Object>();
    abilities.put(albumId, album_ability);
    Map<String, Object> claims = new Map<String, Object>();
    claims.put('abilities', abilities);
    if (!metadatas.containsKey('attachmentId')) {
      metadatas.put('attachmentId', attachmentId);
    }

    Map<String, Object> import_payload = new Map<String, Object>();
    import_payload.put('filename', attachment.name);
    import_payload.put('metadatas', metadatas);
    import_payload.put('album_id', albumId);
    import_payload.put('attachment_id', attachmentId);
    import_payload.put('import_type', 'salesforce');

    return this.post('/imports/', Blob.valueOf(JSON.serialize(import_payload)), claims);
  }

  global Object upload_attachment(Id attachmentId, String albumId) {
    Map<String, Object> metadatas = new Map<String, Object>();
    return upload_attachment(attachmentId, albumId, metadatas);
  }

  /**
   * Retrieves all tags from an image
   * @param  albumId Album ID of image to get tags for
   * @param  imageId Image ID of image to get tags for
   * @param  tags    List of possible tags on image
   * @return         List of tags on image
   */
  global List<String> getTagsOnImage(String albumId, String imageId, List<String> tags) {
    Map<String, Object> albumTags = new Map<String, Object>();
    for (String tag : tags) {
      albumTags.put(tag, '');
    }
    Map<String, Object> params = new Map<String, Object> {
        'abilities' => new Map<String, Object> {
            albumId => new Map<String, Object> {
                'Access' => new Map<String, Object> {
                    'see' => true,
                    'image_tag' => true
                },
                'Tags' => albumTags
            }
        }
    };
    Integer page = 1;
    List<Object> tagImagesPage = new List<Object>();
    List<Object> allTagImages = new List<Object>();
    do {
      tagImagesPage = (List<Object>)this.get('/tag_images?album_id=' + albumId + '&image_id=' + imageId + '&page=' + page++, params);
      allTagImages.addAll(tagImagesPage);
    } while (tagImagesPage.size() == 25);
    List<String> tagsOnImage = new List<String>();
    for (Object tagImage : allTagImages) {
        tagsOnImage.add((String)((Map<String, Object>)((Map<String, Object>)tagImage).get('tag')).get('name'));
    }
    return tagsOnImage;
  }

  /**
   * Clears tags from a tagged image
   * @param  albumId Album ID of image to untag
   * @param  imageId Public ID of the image to untag
   * @param  tags    List of tags to remove from image
   * @return         True if tags removed, false otherwise
   */
  global Boolean removeTag(String albumId, String imageId, String[] tags) {
    try {
      Map<String, Object> albumTags = new Map<String, Object>();
      for (String tag : tags) {
        albumTags.put(tag, '');
      }
      Map<String, Object> claims = new Map<String, Object> {
        'abilities' => new Map<String, Object> {
          albumId => new Map<String, Object> {
            'Access' => new Map<String, Object> {
              'see' => true
            },
            'Tags' => albumTags
          }
        }
      };
      List<Object> tagImages = (List<Object>)this.get('/tag_images?image_id=' + imageId, claims);
      for (Object tagImage : tagImages) {
        this.destroy('/tag_images/' + (String)((Map<String, Object>)tagImage).get('id'), claims);
      }
      return true;
    } catch (Exception e) {
      throw new SharinPixException(e.getCause() + '[' + e.getLineNumber() + ']: ' + e.getMessage());
    }
  }

  global Boolean clear_tag_image(String albumId, String imageId, String[] tags) {
    Map<String, Object> album_access = new Map<String, Object>();
    album_access.put('see', true);
    Map<String, String> album_tags = new Map<String, String>();
    for (String tag : tags) {
      album_tags.put(tag, '');
    }
    Map<String, Object> album_ability = new Map<String, Object>();
    album_ability.put('Access', album_access);
    album_ability.put('Tags', album_tags);
    Map<String, Object> abilities = new Map<String, Object>();
    abilities.put(albumId, album_ability);
    Map<String, Object> claims = new Map<String, Object>();
    claims.put('abilities', abilities);
    List<Object> tag_images = (List<Object>)this.get('/tag_images?image_id='+imageId, claims);
    for (Object tag_image_object : tag_images) {
      Map<String, Object> tag_image = (Map<String, Object>)tag_image_object;
      String id = (String)tag_image.get('id');
      this.destroy('/tag_images/' + Id, claims);
    }
    return true;
  }

  /**
   * Add a tag to an image
   * @param  albumId Album ID of image to tag
   * @param  imageId Public ID of the image to tag
   * @param  tagName Name of tag to add to image
   * @return         Map containing the newly created tag image details
   */
  global Object addTag(String albumId, String imageId, String tagName) {
    Map<String, Object> claims = new Map<String, Object> {
      'abilities' => new Map<String, Object> {
        albumId => new Map<String, Object> {
          'Access' => new Map<String, Object> {
            'see' => true
          },
          'Tags' => new Map<String, Object> {
            tagName => ''
          }
        }
      }
    };
    Object tagImageObj = this.post(
      '/tags/' + EncodingUtil.urlEncode(tagName, 'UTF-8').replaceAll('\\+', '%20') + '/tag_images',
      Blob.valueOf('{"image_ids":["' + imageId + '"]}'),
      claims
    );
    return (Map<String, Object>)tagImageObj;
  }

  global Object add_tag_image(String albumId, String imageId, String tagName) {
    Map<String, Object> album_access = new Map<String, Object>();
    album_access.put('see', true);
    Map<String, String> album_tags = new Map<String, String>();
    album_tags.put(tagName, '');
    Map<String, Object> album_ability = new Map<String, Object>();
    album_ability.put('Access', album_access);
    album_ability.put('Tags', album_tags);
    Map<String, Object> abilities = new Map<String, Object>();
    abilities.put(albumId, album_ability);
    Map<String, Object> claims = new Map<String, Object>();
    claims.put('abilities', abilities);
    return this.post('/tags/' + tagName + '/tag_images', Blob.valueOf('{"image_ids": ["' + imageId + '"]}'), claims);
  }

  global String token(Map<String, Object> claims) {
    return new Token(this.client_id, this.client_secret, claims).issue();
  }

  /**
   * Verify whether secret is correctly configured
   * @return true if secret is configured, false otherwise
   */
  global Boolean test_api() {
    try {
      Map<String, Object> response = (Map<String, Object>)this.get('/organization', new Map<String, Object>());
      System.assert(response.containsKey('id'));
      return true;
    }
    catch (Exception e) {
      return false;
    }
  }

  /**
   * Get image details
   * @param imageId Public ID of image to fetch details on
   * @return        Map containing image details
   */
  global Map<String, Object> getImageDetails(String albumId, String imageId) {
    Object imageObj = this.get(
      '/images/' + imageId,
      new Map<String, Object>{
        'abilities' => new Map<String, Object> {
          albumId => new Map<String, Object> {
            'Access' => new Map<String, Boolean> {
              'see' => true,
              'image_list' => true
            }
          }
        }
      }
    );
    return (Map<String, Object>)imageObj;
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
    return this.getImageUrl(imageId, new Map<String, Object> { 'download' => false }, new List<Object> { transfomation });
  }

  /**
   * Get all images from an album. Cast image object as Map<String, Object> to access attributes
   * @param albumId ID of the album to retrieve images for
   * @return        List of image objects
   */
  public List<Object> getAlbumImages(String albumId) {
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
      pageImages = (List<Object>)this.get('/albums/' + albumId + '/images?page=' + page++, albumParams);
      albumImages.addAll(pageImages);
    } while (pageImages.size() == 25);
    return albumImages;
  }

  /**
   * Get URL of transformed image
   * @param  imageId         Public ID of image to transform
   * @param  sharinpix       SharinPix transformations
   * @param  transformations Image transformations
   * @return                 URL of transformed image
   */
  public String getImageUrl(String imageId, Map<String, Object> sharinpix, List<Object> transformations) {
    Map<String, Object> params = new Map<String, Object> {
      'id' => imageId,
      'sharinpix' => sharinpix,
      'transformations' => transformations
    };
    HTTPRequest request = new HTTPRequest();
    request.setMethod('GET');
    request.setEndpoint(API_URL + '/images/' + imageId + '?token=' + token(params));
    HTTPResponse response = (new HTTP()).send(request);
    return response.getHeader('Location');
  }

  /* AirRefund : */
  @deprecated
  global String upload_attachment_to_album(id attachmentId, string albumId) {
    upload_attachment(attachmentId, albumId);
    return '';
  }
  @deprecated
  global String delete_tag_image(String a, String b) {
    return null;
  }
  @deprecated
  global String add_tag_image(String a, String b) {
    return null;
  }
  @deprecated
  global Map<String, Object> api_delete(String endpoint, Map<String, Object> claims) {
    destroy(endpoint, claims);
    return null;
  }
  @deprecated
  global Map<String, Object> api_get(String endpoint, Map<String, Object> claims) {
    return (Map<String, Object>)get(endpoint, claims);
  }
  @deprecated
  global Map<String, Object> api_post(String endpoint, Blob body, Map<String, Object> claims) {
    return (Map<String, Object>)post(endpoint, body, claims);
  }
}
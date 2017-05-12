global with sharing class Client {
  private static Client instance = null;

  global String client_id { get; set; }
  global String client_secret { get; set; }
  global String endpoint_url { get; set; }

  /**
   * Get SharinPix Client instance based on organization's credentials
   * @return SharinPix Client instance
   */
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

  /**
   * SharinPix Client constructor
   * @param  client_id     SharinPix client ID obtained from SharinPix administration dashboard
   * @param  client_secret SharinPix client secret obtained from SharinPix administration dashboard
   * @param  endpoint_url  SharinPix API endpoint (usually https://api.sharinpix.com/api/v1)
   * @return               SharinPix Client instance
   */
  global Client(String client_id, String client_secret, String endpoint_url) {
    this.client_id = client_id;
    this.client_secret = client_secret;
    this.endpoint_url = endpoint_url;
  }

  /**
   * SharinPix Client constructor
   * @param  sharinpixUrl Client URL obtained from SharinPix administration dashboard (sharinpix://cliendId:clientSecret@apiEndpoint)
   * @return              SharinPix Client instance
   */
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
   * Returns the current SharinPix domain URL
   * @return SharinPix domain URL for client
   */
  global String getHost() {
    Url u = new Url(this.endpoint_url);
    return u.getProtocol() + '://' + u.getHost();
  }

  /**
   * Returns the current SharinPix app domain URL
   * @return SharinPix app domain URL for client
   */
  global String getAppHost() {
    Url u = new Url(this.endpoint_url);
    String host = u.getHost();
    if (host.equals('api.sharinpix.com')) {
      host = 'app.sharinpix.com';
    }
    return u.getProtocol() + '://' + host;
  }

  /**
   * Returns the current SharinPix API URL
   * @return SharinPix API endpoint URL for client
   */
  global String getApiUrl() {
    return this.endpoint_url;
  }

  /**
   * Encodes a URL to UTF-8 and uses %20 for spaces
   * @param  unencoded Unencoded URL
   * @return           Encoded URL
   */
  global String urlEncode(String unencoded) {
    return EncodingUtil.urlEncode(unencoded, 'UTF-8').replaceAll('\\+', '%20');
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

  /**
   * Generate SharinPix token
   * @param  claims Parameters to put in token
   * @return        Token string
   */
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

  /* Moved to Utils : */
  @deprecated
  global Boolean renameAlbum(String oldAlbumId, String newAlbumId) {
    return (new Utils()).renameAlbum(oldAlbumId, newAlbumId);
  }

  @deprecated
  global Object upload_attachment(id attachmentId, string albumId, Map<String, Object> metadatas) {
    return (new Utils()).uploadAttachment(attachmentId, albumId, metadatas);
  }

  @deprecated
  global Object upload_attachment(Id attachmentId, String albumId) {
    return (new Utils()).uploadAttachment(attachmentId, albumId);
  }

  @deprecated
  global Boolean clear_tag_image(String albumId, String imageId, String[] tags) {
    return (new Utils()).removeTags(imageId, tags);
  }

  @deprecated
  global Object add_tag_image(String albumId, String imageId, String tagName) {
    return (new Utils()).addTag(imageId, tagName);
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

  /* Unused : */
  @deprecated
  global List<String> getTagsOnImage(String albumId, String imageId, List<String> tags) {
    return null;
  }
  @deprecated
  global Boolean removeTag(String albumId, String imageId, String[] tags) {
    return false;
  }
  @deprecated
  global Object addTag(String albumId, String imageId, String tagName) {
    return null;
  }
  @deprecated
  global Map<String, Object> getImageDetails(String albumId, String imageId) {
    return null;
  }
  @deprecated
  global String croppedImageUrl(String imageId, String cropStyle, Integer width, Integer height) {
    return null;
  }
  @deprecated
  global List<Object> getAlbumImages(String albumId) {
    return null;
  }
  @deprecated
  global String getImageUrl(String imageId, Map<String, Object> sharinpix, List<Object> transformations) {
    return null;
  }
}
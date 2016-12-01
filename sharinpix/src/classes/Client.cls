global with sharing class Client {
  private static Client instance = null;

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

  global String client_id {get;set;}
  global String client_secret {get;set;}
  global String endpoint_url {get;set;}

  global Client(String client_id, String client_secret, String endpoint_url){
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

  global Object post(String endpoint, Blob body, Map<String, Object> claims){
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
      throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
    }
    return new Map<String, Object>();
  }

  global Object put(String endpoint, Blob body, Map<String, Object> claims){
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('PUT');
    req.setHeader('Authorization', 'Token token="' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    req.setBodyAsBlob(body);
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatus() == 'OK'){
      return JSON.deserializeUntyped(response.getBody());
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
    }
    return new Map<String, Object>();
  }

  global Object get(String endpoint, Map<String, Object> claims){
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('GET');
    req.setHeader('Authorization', 'Token token="' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatus() == 'OK'){
      return JSON.deserializeUntyped(response.getBody());
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': ' + response.getBody());
    }
  }

  global boolean destroy(String endpoint, Map<String, Object> claims){
    HttpRequest req = new HttpRequest();
    req.setEndpoint(this.endpoint_url + endpoint);
    req.setMethod('DELETE');
    req.setHeader('Authorization', 'Token token=\"' + token(claims) + '"');
    req.setHeader('Content-Type', 'application/json');
    Http http = new Http();
    HTTPResponse response = http.send(req);
    if (response.getStatusCode() == 204){
      return true;
    } else {
      throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
    }
    return false;
  }

  global Object upload_attachment(id attachmentId, string albumId, Map<String, Object> metadatas){
    if (!(Schema.sObjectType.Attachment.isAccessible() &&
        Schema.sObjectType.Attachment.fields.Id.isAccessible() &&
        Schema.sObjectType.Attachment.fields.Name.isAccessible() &&
        Schema.sObjectType.Attachment.fields.Body.isAccessible()))
    {
      throw new SharinPixException('Insufficient privilege');
      return null;
    }
    Attachment attachment = [SELECT Id, name FROM Attachment WHERE Id=:attachmentId LIMIT 1];

    Boolean b_true = true;
    Map<String, Object> album_access = new Map<String, Object>();
    album_access.put('see', b_true);
    album_access.put('image_upload', b_true);
    Map<String, Object> album_ability = new Map<String, Object>();
    album_ability.put('Access', album_access);
    Map<String, Object> abilities = new Map<String, Object>();
    abilities.put(albumId, album_ability);
    Map<String, Object> claims = new Map<String, Object>();
    claims.put('abilities', abilities);
    if(!metadatas.containsKey('attachmentId')){
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

  global Object upload_attachment(id attachmentId, string albumId){
    Map<String, Object> metadatas = new Map<String, Object>();
    return upload_attachment(attachmentId, albumId, metadatas);
  }

  global boolean clear_tag_image(String albumId, String imageId, String[] Tags){
    Map<String, Object> album_access = new Map<String, Object>();
    album_access.put('see', true);
    Map<String, String> album_tags = new Map<String, String>();
    for(String tag : Tags){
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
    for(Object tag_image_object : tag_images){
      Map<String, Object> tag_image = (Map<String, Object>)tag_image_object;
      String id = (String)tag_image.get('id');
      this.destroy('/tag_images/'+id, claims);
    }
    return true;
  }

  global Object add_tag_image(String albumId, String imageId, String tagName){
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
    return this.post('/tags/'+tagName+'/tag_images', Blob.valueof('{"image_ids": ["'+ImageId+'"]}'), claims);
  }

  global string token(Map<String, Object> claims){
    return new Token(this.client_id, this.client_secret, claims).issue();
  }

  global boolean test_api(){
    try {
      Map<String, Object> response = (Map<String, Object>)this.get('/organization', new map<String, object>());
      if(response.containsKey('id')){
        return true;
      } else {
        return false;
      }
    }
    catch(Exception e){
      return false;
    }
  }

  /* AirRefund : */
  @deprecated
  global String upload_attachment_to_album(id attachmentId, string albumId){
    upload_attachment(attachmentId, albumId);
    return '';
  }
  @deprecated
  global String delete_tag_image(String a, String b){
    return null;
  }
  @deprecated
  global String add_tag_image(String a, String b){
    return null;
  }
  @deprecated
  global Map<String, Object> api_delete(String endpoint, Map<String, Object> claims){
    destroy(endpoint, claims);
    return null;
  }
  @deprecated
  global Map<String, Object> api_get(String endpoint, Map<String, Object> claims){
    return (Map<String, Object>)get(endpoint, claims);
  }
  @deprecated
  global Map<String, Object> api_post(String endpoint, Blob body, Map<String, Object> claims){
    return (Map<String, Object>)post(endpoint, body, claims);
  }
}
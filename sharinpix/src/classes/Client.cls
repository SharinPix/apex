global class Client {
    private static Client instance = null;

    global static Client getInstance(){
        Credential__c cr = Credential__c.getOrgDefaults();
        if(instance == null) instance = new Client(cr.Client_Id__c, cr.Client_Secret__c, cr.Endpoint_Url__c);
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

    global Object post(String endpoint, Blob body, Map<String, Object> claims){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint_url + endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Token token="' + token(claims) + '"');
        req.setHeader('Content-Type', 'application/json');
        req.setBodyAsBlob(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        if (response.getStatus() == 'OK'){
            return JSON.deserializeUntyped(response.getBody());
        }else{
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
        }else{
            throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
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
        }else{
            throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
        }
        return false;
    }

    private static String post_file(String url, String attachmentId, Map<String, Object> params){
        String boundary = '----------------------------741e90d31eff';
        String header = '';
        for (String param_name : params.keySet()) {
            header += '--' + boundary + '\r\nContent-Disposition: form-data; name="' + param_name + '"\r\n\r\n' + params.get(param_name)+ '\r\n';
        }
        header += '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+[select id, name from Attachment where id = :attachmentId limit 1].Name+'"\r\nContent-Type: application/octet-stream';
        String footer = '\r\n--'+boundary+'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('=')) {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        if(EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body).endsWith('=')){
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
            req.setHeader('X-Requested-With','XMLHttpRequest');
            req.setMethod('POST');
            req.setEndpoint(url);
            req.setBodyAsBlob(EncodingUtil.base64Decode(headerEncoded+EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body).substring(0,EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body).length()-4)+EncodingUtil.base64Encode(Blob.valueOf(EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body).substring(EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body).length()-4,EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body).length())+footer))));
            req.setTimeout(120000);
            Http http = new Http();
            HTTPResponse response = http.send(req);
            return response.getBody();
        }else{
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
            req.setHeader('X-Requested-With','XMLHttpRequest');
            req.setMethod('POST');
            req.setEndpoint(url);req.setBodyAsBlob(EncodingUtil.base64Decode(headerEncoded+EncodingUtil.base64Encode([select id, name, body from Attachment where id = :attachmentId limit 1].Body)+EncodingUtil.base64Encode(Blob.valueOf(footer))));
            req.setTimeout(120000);
            Http http = new Http();
            HTTPResponse response = http.send(req);
            return response.getBody();
        }
    }

    global Object upload_attachment(id attachmentId, string albumId){
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
        Map<String, Object> album = (Map<String, Object>)this.get('/albums/'+albumId, claims);
        Map<String, Object> upload_form = (Map<String, Object>) album.get('upload_form');
        Map<String, Object> params = (Map<String, Object>) upload_form.get('params');
        String url = (String) upload_form.get('url');
        String cloudinary = post_file(url, attachmentId, params);
        return this.post(
                '/albums/'+albumId+'/images',
                Blob.valueof('{"cloudinary":' + cloudinary + '}'),
                claims
                );
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

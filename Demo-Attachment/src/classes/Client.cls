public class Client {
    public String client_id {get;set;}
    public String client_secret {get;set;}
    public String endpoint_url {get;set;}
    
    public static final String API_URL = 'https://api.sharinpix.com/api/v1';
    public Client(String client_id, String client_secret, String endpoint_url){
        this.client_id = client_id;
        this.client_secret = client_secret;
        this.endpoint_url = endpoint_url;
    }
    public Map<String, Object> api_post(String endpoint, Blob body, Token token){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint_url + endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Token token=\"' + token.issue() + '"');
        req.setHeader('Content-Type', 'application/json');
        req.setBodyAsBlob(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
        if (response.getStatus() == 'OK'){
            Map<String, Object> json_res = new Map<String, Object>();
            json_res = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            return json_res;
        }else{
            throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
        }
        return new Map<String, Object>();
    }
    public Map<String, Object> api_get(String endpoint, Token token){
        System.debug('*****Token : ');
        System.debug(token.issue());
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint_url + endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Token token=\"' + token.issue() + '"');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
        if (response.getStatus() == 'OK'){
            Map<String, Object> json_res = new Map<String, Object>();
            json_res = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            return json_res;
        }else{
            throw new SharinPixException('API response ' + response.getStatus() + ': '+ response.getBody());
        }
    }
    public static String post_file(String url, String file_name, Blob file_body, Map<String, Object> params){
        String boundary = '----------------------------741e90d31eff';
        String header = '';
        for (String param_name : params.keySet()) {
          header += '--' + boundary + '\r\nContent-Disposition: form-data; name="' + param_name + '"\r\n\r\n' + params.get(param_name)+ '\r\n';
        }
        header += '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+file_name+'"\r\nContent-Type: application/octet-stream';
        String footer = '\r\n--'+boundary+'--';              
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('=')) {
           header+=' ';
           headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        System.debug(header);
        String bodyEncoded = EncodingUtil.base64Encode(file_body);
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        if(last4Bytes.endsWith('=')){
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest tmp = new HttpRequest();
            tmp.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = tmp.getBody()+footer;   
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded.substring(0,bodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        }else{
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        req.setHeader('X-Requested-With','XMLHttpRequest');
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setBodyAsBlob(bodyBlob);
        req.setTimeout(120000);

        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
        return response.getBody();
    }
    public String upload_image_to_album(String filename, Blob file, String album_id){
        Boolean b_true = true;
        Map<String, Object> album_access = new Map<String, Object>();
        album_access.put('see', b_true);
        album_access.put('image_upload', b_true);
        Map<String, Object> album_ability = new Map<String, Object>();
        album_ability.put('Access', album_access);
        Map<String, Object> abilities = new Map<String, Object>();
        abilities.put(album_id, album_ability);
        Map<String, Object> claims = new Map<String, Object>();
        claims.put('abilities', abilities);
        
        Token token = new Token(this, claims);
        
        Map<String, Object> album = this.api_get('/albums/'+album_id, token);
        Map<String, Object> upload_form = (Map<String, Object>) album.get('upload_form');
        Map<String, Object> params = (Map<String, Object>) upload_form.get('params');
        System.debug('params');
        System.debug(params);
        String url = (String) upload_form.get('url');
        System.debug('url');
        System.debug(url);

        String cloudinary = post_file(url, filename, file,params);
        Blob payload = Blob.valueof('{"cloudinary":' + cloudinary + '}');
        Map<String, Object> image = this.api_post('/albums/'+album_id+'/images', payload , token);
        return '';
    }
    public static void upload_attachment(String attachment_id, String album_id){
        Attachment attachment = [SELECT Id, Name, Body FROM Attachment WHERE Id=:attachment_id LIMIT 1];
        System.debug(attachment);
        Client sp = new Client('bef8076a-995e-48f7-a5fa-683a9c506e4a', 'fab308eafd600629837525d67bcf10bb', 'https://19df3d0.ngrok.com/api/v1');
        sp.upload_image_to_album(attachment.name, attachment.body, album_id);
    }
}
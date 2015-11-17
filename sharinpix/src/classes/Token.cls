public class Token {
    public JWT jwt {get;set;}
    public Client client {get;set;}
    public Token(Client client, Map<String, Object> claims){
        this.client = client;
        this.jwt = new JWT('HS256');
        this.jwt.iss = this.client.client_id;
        this.jwt.privateKey = this.client.client_secret;
        this.jwt.claims = claims;
    }
    public String issue(){
        System.debug('*****Token : ');
        System.debug(jwt.issue());
        return jwt.issue();
    }
}
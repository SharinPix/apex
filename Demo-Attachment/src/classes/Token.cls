public class Token {
    public JWT jwt {get;set;}
    public Token(string client_id, string client_secret, Map<String, Object> claims){
        this.jwt = new JWT('HS256');
        this.jwt.iss = client_id;
        this.jwt.privateKey = client_secret;
        this.jwt.claims = claims;
    }
    public String issue(){
        return jwt.issue();
    }  
}
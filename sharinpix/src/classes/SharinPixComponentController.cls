public with sharing class SharinPixComponentController {
    public string parametersInput {get; set;}
    public string heightInput{get; set;}
    public string iframeIdInput{get; set;}
    public string secretUrlInput{get; set;}
    public sharinpix.client getClient(){
        if(secretUrlInput != ''){
            return new sharinpix.client(secretUrlInput);
        }
        return sharinpix.client.getInstance();
    }
    public string getUrl(){
        // Should be return sharinpix.client.getInstance().url('pagelayout/plop', getClaims());
        return this.getClient().endpoint_url+'/../../?token=' + this.getClient().token(getParameters());
    }
    public map<string, object> getParameters(){
        return (map<string, object>) JSON.deserializeUntyped(parametersInput.replace('\'', '"'));
    }
    public string getIframeId(){
        return iframeIdInput;
    }
    public string getStyle(){
        return 'border: none; width: 100%; height: '+ heightInput + ';';
    }
}
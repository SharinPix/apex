public with sharing class SharinPixComponentController {
    public String parametersInput { get; set; }
    public String heightInput { get; set; }
    public String iframeIdInput { get; set; }
    public String secretUrlInput { get; set; }

    public sharinpix.client getClient() {
        if(String.IsNotBlank(secretUrlInput)) {
            return new sharinpix.client(secretUrlInput);
        }
        return sharinpix.client.getInstance();
    }

    public String getUrl(){
        // Should be return sharinpix.client.getInstance().url('pagelayout/plop', getClaims());
        return this.getClient().getAppHost() + '?token=' + this.getClient().token(sharinpix.Utils.parseJsonParam(parametersInput));
    }

    public String getIframeId(){
        return iframeIdInput;
    }

    public String getStyle(){
        return 'border: none; width: 100%; height: ' + heightInput + ';';
    }
}
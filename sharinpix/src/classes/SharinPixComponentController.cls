public with sharing class SharinPixComponentController {
    public String parametersInput { get; set; }
    public String heightInput { get; set; }
    public String iframeIdInput { get; set; }
    public String secretUrlInput { get; set; }

    public sharinpix.Client getClient() {
        if (String.isNotBlank(secretUrlInput)) {
            return new sharinpix.Client(secretUrlInput);
        }
        return sharinpix.Client.getInstance();
    }

    public String getUrl() {
        // Should be return sharinpix.client.getInstance().url('pagelayout/plop', getClaims());
        Map<String, Object> parameters = sharinpix.Utils.parseJsonParam(parametersInput);
        if (parameters.get('path') == null) {
            String albumId = String.valueOf(parameters.get('Id'));
            return this.getClient().getAppHost() + '/pagelayout/' + albumId + '?token=' + this.getClient().token(parameters);
        } else {
            return this.getClient().getAppHost() + '?token=' + this.getClient().token(parameters);
        }
    }

    public String getIframeId() {
        return iframeIdInput;
    }

    public String getStyle() {
        return 'border: none; width: 100%; height: ' + heightInput + ';';
    }
}
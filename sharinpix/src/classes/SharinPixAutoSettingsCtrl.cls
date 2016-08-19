public with sharing class SharinPixAutoSettingsCtrl {

  public String parameters{ get; set; }

  public SharinPixAutoSettingsCtrl() {
    parameters = JSON.serialize(new Map<String, Object> { 'admin' => true, 'path' => '/admin' });
  }

  @RemoteAction
  public static boolean hasValidSecret() {
    Client clientInstance = Client.getInstance(); // TODO SharinPix.Client
    return clientInstance.test_api();
  }

  @RemoteAction
  public static boolean saveSecret(String sharinpixUrl) {
    try {
      Credential2__c credential = Credential2__c.getOrgDefaults();
      credential.SharinPix_URL__c = sharinpixUrl;
      credential.Client_Id__c = sharinpixUrl.substring(sharinpixUrl.indexOf('/') + 2, sharinpixUrl.indexOf(':', 10));
      credential.Client_Secret__c = sharinpixUrl.substring(sharinpixUrl.indexOf(':', 10) + 1, sharinpixUrl.indexOf('@'));
      credential.Endpoint_Url__c = 'https://' + sharinpixUrl.substring(sharinpixUrl.indexOf('@') + 1);
      upsert credential;
      return true;
    } catch (Exception e) {
      return false;
    }
  }
}
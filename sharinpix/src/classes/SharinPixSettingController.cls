public with sharing class SharinPixSettingController {
  public String parameters{ get; set; }

  public SharinPixSettingController() {
    parameters = JSON.serialize(new Map<String, Object> { 'admin' => true, 'path' => '/admin' });
  }

  @RemoteAction
  public static boolean hasValidSecret() {
    Credential__c credential = Credential__c.getOrgDefaults();
    if (credential.Id == null || credential.OrganizationId__c != UserInfo.getOrganizationId()){
      return false;
    }
    Client clientInstance = Client.getInstance();
    return clientInstance.test_api();
  }

  @RemoteAction
  public static boolean saveSecret(String sharinpixUrl, string orgId) {
    try {
      Credential__c credential = Credential__c.getOrgDefaults();
      credential.SharinPix_URL__c = sharinpixUrl;
      credential.Client_Id__c = sharinpixUrl.substring(sharinpixUrl.indexOf('/') + 2, sharinpixUrl.indexOf(':', 10));
      credential.Client_Secret__c = sharinpixUrl.substring(sharinpixUrl.indexOf(':', 10) + 1, sharinpixUrl.indexOf('@'));
      credential.Endpoint_Url__c = 'https://' + sharinpixUrl.substring(sharinpixUrl.indexOf('@') + 1);
      credential.OrganizationId__c = orgId;
      upsert credential;
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  @RemoteAction
  public static String getOrgInfos() {
    return JSON.serialize([SELECT Id, InstanceName, IsSandbox, Name, OrganizationType FROM Organization LIMIT 1]);
  }
}
public with sharing class TokenGeneratorController {
//kevan 20170303
//
    public Id recordId {get;set;}
    public SharinPixPermission__c token {get;set;}
    public String vfMode {get; set;}
    public Map<String, String> urlparams = new Map<String, String>();

    public TokenGeneratorController(ApexPages.StandardController controller){
        recordId = controller.getId();
        if (string.isNotBlank(recordId)){
            token = [select id, name, description__c, json__c from SharinPixPermission__c where id = :recordId limit 1];
        }
        else {
            token = new SharinPixPermission__c();
        }

        urlparams = ApexPages.currentPage().getParameters();
        if (urlparams.get('id') == null){
            vfMode = 'New';
        } else if (urlparams.get('id') != null & urlparams.get('retURL') != null) {
            vfMode = 'Edit';
        } else if (urlparams.get('id') != null & urlparams.get('retURL') == null){
            vfMode = 'View';
        }
    }

    public PageReference cancelEdit(){
        PageReference pageref = new PageReference(urlparams.get('retURL'));
        pageref.setRedirect(true);
        return pageref;
    }

    public PageReference updateToken(){
        system.debug('#### '+token);
        upsert token;
        PageReference pageref = new PageReference('/'+token.Id);
        pageref.setRedirect(true);
        return pageref;
    }
}
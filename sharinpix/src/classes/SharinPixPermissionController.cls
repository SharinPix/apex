public with sharing class SharinPixPermissionController {
//kevan 20170303

    public Id recordId {get;set;}
    public SharinPixPermission__c permission {get;set;}
    public String vfMode {get; set;}
    public Map<String, String> urlparams = new Map<String, String>();
    public string name {get;set;}
    public string description {get;set;}
    public string jsonfile {get;set;}

    public SharinPixPermissionController(ApexPages.StandardController controller){
        recordId = controller.getId();
        if (string.isNotBlank(recordId)){
            permission = [select id, name, description__c, json__c from SharinPixPermission__c where id = :recordId limit 1];
            name = permission.Name;
            description = permission.Description__c;
            jsonfile = permission.Json__c;
        }
        else {
            permission = new SharinPixPermission__c();
        }

        urlparams = ApexPages.currentPage().getParameters();
        if (recordId == null){
            vfMode = 'New';
        }
        else {
            if (urlparams.get('retURL') != null){
                vfMode = 'Edit';
            }
            else {
                vfMode = 'View';
            }
        }
    }

    public PageReference cancelEdit(){
        PageReference pageref = new PageReference(Url.getSalesforceBaseUrl().toExternalForm()+urlparams.get('retURL'));
        pageref.setRedirect(true);
        return pageref;
    }

    public PageReference updatePermission(){
        list<Schema.SobjectField> fields = new list<Schema.SobjectField>{Schema.sobjecttype.SharinPixPermission__c.fields.Name.getSObjectField(),
                                                                         Schema.sobjecttype.SharinPixPermission__c.fields.Description__c.getSObjectField(),
                                                                         Schema.sobjecttype.SharinPixPermission__c.fields.Json__c.getSObjectField()};

        if (CRUD.isCreateable(permission.getSObjectType(), fields) || CRUD.isUpdateable(permission.getSObjectType(), fields)){
            permission.Name = name;
            permission.Description__c = description;
            permission.Json__c = jsonfile;
            upsert permission;
        }
        PageReference pageref = new PageReference(Url.getSalesforceBaseUrl().toExternalForm()+'/'+permission.Id);
        pageref.setRedirect(true);
        return pageref;
    }
}




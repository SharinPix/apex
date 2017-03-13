public class SharinPixPermissionController {
//kevan 20170303

    public Id recordId {get;set;}
    public SharinPixPermission__c permission {get;set;}
    public String vfMode {get; set;}
    public Map<String, String> urlparams = new Map<String, String>();

    public SharinPixPermissionController(ApexPages.StandardController controller){
        recordId = controller.getId();
        if (string.isNotBlank(recordId)){
            permission = [select id, name, description__c, json__c from SharinPixPermission__c where id = :recordId limit 1];
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
        PageReference pageref = new PageReference(urlparams.get('retURL'));
        pageref.setRedirect(true);
        return pageref;
    }

    public PageReference updatePermission(){
        upsert permission;
        PageReference pageref = new PageReference('/'+permission.Id);
        pageref.setRedirect(true);
        return pageref;
    }
}
global with sharing class TagActionController {
	@RemoteAction
	global static object executeCommand(id recordId, string jsonfile){
		SObjectWrapper sobjwrapper = new SObjectWrapper(recordId, jsonfile);
		Database.SaveResult result = sobjwrapper.executeAction();
		return result;
	}
}
/**
 * Class for Einstein triggers
 * @author Kevan
 * @since April 2017
 */
public with sharing class EinsteinTriggerUtils {
    /**
     * Call SharinPix api to create dataset
     * @param datasetId Salesforce id of the dataset
     */
    @future(callout=true)
    public static void createSharinPixDataset(Id datasetId){
        EinsteinDataset__c dataset = [select id, name, EinsteinVisionProject__c from EinsteinDataset__c where id = :String.escapeSingleQuotes(datasetId)];
        list<EinsteinLabel__c> einsteinLabels = [select id, name from EinsteinLabel__c where EinsteinVisionProject__c = :String.escapeSingleQuotes(dataset.EinsteinVisionProject__c)];
        list<string> labels = new list<string>();
        for(EinsteinLabel__c label: einsteinLabels){
            labels.add(label.name);
        }
        map<string, string> payload = new map<string, string>{
            'name' => dataset.name,
            'sfid' => dataset.Id,
            'labels' => String.join(labels, ','),
            'albumId' => dataset.EinsteinVisionProject__c
        };
        Client clientInstance = Client.getInstance();
        object response = clientInstance.post('/einstein_dataset', Blob.valueof(JSON.serialize(payload)), new map<string, object>{'einstein'=>true});
    }

    /**
     * Call SharinPix api to create model
     * @param modelId Salesforce id of the model
     */
    @future(callout=true)
    public static void createSharinPixModel(id modelId){
        EinsteinModel__c model = [select Id, Name, Epochs__c, TrainParams__c, LearningRate__c, EinsteinDataset__c from EinsteinModel__c where Id = :modelId];
        map<string, object> payload = new map<string, object>{
            'name' => model.name,
            'sfid' => model.Id,
            'epochs' => model.Epochs__c,
            'learningRate' => model.LearningRate__c,
            'trainParams' => model.TrainParams__c,
            'datasetSfid' => model.EinsteinDataset__c
        };
        Client clientInstance = Client.getInstance();
        object response = clientInstance.post('/einstein_model', Blob.valueof(JSON.serialize(payload)), new map<string, object>{'einstein'=>true});
    }
}
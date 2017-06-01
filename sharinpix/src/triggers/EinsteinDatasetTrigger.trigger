/**
 * Trigger to create Einstein Dataset on SharinPix
 * @author    Kevan
 * @since     April 2017
 */
trigger EinsteinDatasetTrigger on EinsteinDataset__c (after insert) {

    list<id> ids = new list<id>();
    for (EinsteinDataset__c dataset: Trigger.new){
        ids.add(dataset.id);
    }
    if(ids.size() == 1){
        EinsteinTriggerUtils.createSharinPixDataset(ids[0]);
    }
}
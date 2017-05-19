/**
 * Trigger to create Einstein Dataset on SharinPix
 * @author    Kevan
 * @since     April 2017
 */
trigger EinsteinDatasetTrigger on EinsteinDataset__c (after insert) {

    for (EinsteinDataset__c dataset: Trigger.new){
        EinsteinTriggerUtils.createSharinPixDataset(dataset.id);
    }
}
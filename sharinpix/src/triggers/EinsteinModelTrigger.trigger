/**
 * Trigger to create Einstein Model on SharinPix
 * @author    Kevan
 * @since     April 2017
 */
trigger EinsteinModelTrigger on EinsteinModel__c (after insert) {

    for (EinsteinModel__c model: Trigger.new){
        EinsteinTriggerUtils.createSharinPixModel(model.id);
    }
}
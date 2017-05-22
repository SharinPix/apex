/**
 * Trigger to create Einstein Model on SharinPix
 * @author    Kevan
 * @since     April 2017
 */
trigger EinsteinModelTrigger on EinsteinModel__c (after insert) {

    list<id> ids = new list<id>();
    for (EinsteinModel__c model: Trigger.new){
        ids.add(model.id);
    }
    if(ids.size() == 1){
        EinsteinTriggerUtils.createSharinPixModel(ids[0]);
    }
}
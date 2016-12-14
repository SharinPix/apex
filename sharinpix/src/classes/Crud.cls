public with sharing class Crud {
    /*
    ----------------------------------------------------------------------
    -- - Author        : SharinPix
    -- - Description   : Manage CRUD in VisualForce page and Lightning Components
    -- -             
    -- - Maintenance History:
    --
    -- Date         Name  Version  Remarks 
    -- -----------  ----  -------  ---------------------------------------
    -- 29-NOV-2016  DMT   1.0      Initial version
    ----------------------------------------------------------------------
    */
    private static Integer ISUPDATEABLE = 1;
    private static Integer ISDELETABLE = 2;
    private static Integer ISCREATEABLE = 3;
    private static Integer ISACCESSIBLE = 4;

    public static boolean isCreateable(Schema.SObjectType sobjType) {
        return ObjectPermission(sobjType, ISCREATEABLE, new list < Schema.SObjectField > ());
    }
    public static boolean isCreateable(Schema.SObjectType sobjType, List < Schema.SObjectField > fieldList) {
        return ObjectPermission(sobjType, ISCREATEABLE, fieldList);
    }
    public static boolean isUpdateable(Schema.SObjectType sobjType) {
        return ObjectPermission(sobjType, ISUPDATEABLE, new list < Schema.SObjectField > ());
    }
    public static boolean isUpdateable(Schema.SObjectType sobjType, List < Schema.SObjectField > fieldList) {
        return ObjectPermission(sobjType, ISUPDATEABLE, fieldList);
    }
    public static boolean isDeletable(Schema.SObjectType sobjType) {
        return ObjectPermission(sobjType, ISDELETABLE, new list < Schema.SObjectField > ());
    }
    public static boolean isDeletable(Schema.SObjectType sobjType, List < Schema.SObjectField > fieldList) {
        return ObjectPermission(sobjType, ISDELETABLE, fieldList);
    }
    public static boolean isAccessible(Schema.SObjectType sobjType) {
        return ObjectPermission(sobjType, ISACCESSIBLE, new list < Schema.SObjectField > ());
    }
    public static boolean isAccessible(Schema.SObjectType sobjType, List < Schema.SObjectField > fieldList) {
        return ObjectPermission(sobjType, ISACCESSIBLE, fieldList);
    }

    public static boolean ObjectPermission(Schema.SObjectType sobjType, Integer permissionType, List < Schema.SObjectField > sObjectFieldList) {
        if ((permissionType == ISCREATEABLE && sobjType.getDescribe().isCreateable()) ||
            (permissionType == ISUPDATEABLE && sobjType.getDescribe().isUpdateable()) ||
            (permissionType == ISACCESSIBLE && sobjType.getDescribe().isAccessible())) {
            for (Schema.SObjectField sObjectField: sObjectFieldList) {
                if (permissionType == ISCREATEABLE && !sObjectField.getDescribe().isCreateable()) {
                    return false;
                }
                if (permissionType == ISUPDATEABLE && !sObjectField.getDescribe().isUpdateable()) {
                    return false;
                }
                if (permissionType == ISACCESSIBLE && !sObjectField.getDescribe().isAccessible()) {
                    return false;
                }
            }
        } else if (permissionType == ISDELETABLE) {
            return sobjType.getDescribe().isDeletable();
        } else {
            return false;
        }
        return true;
    }
}
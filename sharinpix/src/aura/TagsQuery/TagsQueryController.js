({
    toggleTagsFilter : function(component, event, helper) {
        var tagOperator = event.target.id;
        if ($A.util.isEmpty(tagOperator) || tagOperator == 'no-tag') {
            component.set('v.tagOperator', '');
            component.set('v.selectedTags', '');
            component.find('selTagList') && component.find('selTagList').set('v.value', '');
            component.set('v.displayTags', false);
        } else {
            var tagNames = component.get('v.tagNames');
            if ($A.util.isEmpty(tagNames)) {
                helper.fillTagNames(component, function(recvdTagNames) {
                    component.set('v.tagNames', recvdTagNames);
                    component.set('v.displayTags', true);
                });
            } else {
                component.set('v.displayTags', true);
            }
            component.set('v.tagOperator', tagOperator == 'all-tags' ? 'AND' : 'OR');
        }
    },
    setSelectedTags : function(component, event, helper) {
        var value = component.get('v.selection');
        component.set($A.util.isEmpty(value) ? '[]' : JSON.stringify(value.split(';')));
    },
    reset : function(component, event, helper) {
        component.set('v.selectedTags', '');
        component.find('selTagList') && component.find('selTagList').set('v.value', '');
        component.find('no-tag') && component.find('no-tag').set('v.checked', true);
        component.set('v.displayTags', false);
        component.set('v.tagOperator', '');
    }
})
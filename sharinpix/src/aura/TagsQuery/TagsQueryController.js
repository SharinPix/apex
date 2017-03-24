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
                //helper.toggleUiSpinner(component, 'tagSpinner', true)
                helper.fillTagNames(component, function(recvdTagNames) {
                    component.set('v.tagNames', recvdTagNames);
                    component.set('v.displayTags', true);
                    //helper.toggleUiSpinner(component, 'tagSpinner', false)
                });
            } else {
                component.set('v.displayTags', true);
            }
            component.set('v.tagOperator', tagOperator == 'all-tags' ? 'AND' : 'OR');
        }
    }
})
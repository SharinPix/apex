({
    toggleTagsFilter : function(cmp, event, helper) {
        var tagOperator = event.target.id;
        if ($A.util.isEmpty(tagOperator) || tagOperator == 'no-tag') {
            cmp.set('v.tagOperator', '');
            cmp.set('v.tagNames', '');
            cmp.find('selTagList') && cmp.find('selTagList').set('v.value', '');
            cmp.set('v.displayTags', false);
        } else {
            var allTags = cmp.get('v.allTags');
            if ($A.util.isEmpty(allTags)) {
                helper.getAllTags(cmp, function(recvdTags) {
                    cmp.set('v.allTags', recvdTags);
                    cmp.set('v.displayTags', true);
                });
            } else {
                cmp.set('v.displayTags', true);
            }
            cmp.set('v.tagOperator', tagOperator == 'all-tags' ? 'AND' : 'OR');
        }
    },
    setTagNames : function(cmp, event, helper) {
        var value = cmp.get('v.selection');
        cmp.set('v.tagNames', $A.util.isEmpty(value) ? '[]' : JSON.stringify(value.split(';')));
    },
    reset : function(cmp, event, helper) {
        cmp.set('v.tagNames', '');
        cmp.find('selTagList') && cmp.find('selTagList').set('v.value', '');
        cmp.find('no-tag') && cmp.find('no-tag').set('v.checked', true);
        cmp.set('v.displayTags', false);
        cmp.set('v.tagOperator', '');
    }
})
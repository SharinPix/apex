({
    getSearchUrl : function(component, albumIds, tagOperator, selectedTags, callback) {
        var action = component.get("c.generateSearchUrl");
        action.setParams({
            albumIds: albumIds,
            tagOperator: tagOperator,
            selectedTags: selectedTags
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(response.getReturnValue());
            } else if (component.isValid() && state === "ERROR") {
                var errors = response.getError();
                this.showToast('Error', 'See console for details');
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    loadPage : function(component, page) {
        if (page == null || page == 0) return;
        var pageSize = component.get('v.pageSize');
        var currentPage = component.get('v.currentPage');
        var albumIds = component.get('v.albumIds');
        var pagedAlbumIds;
        if (pageSize == 0) {
            pagedAlbumIds = albumIds;
        } else {
            pagedAlbumIds = albumIds.slice(((currentPage-1) * pageSize), currentPage*pageSize);
        }
        var tagOperator = component.get('v.tagOptions')['tagOperator'];
        var selectedTags = component.get('v.tagOptions')['selectedTags'];
        var that = this;
        console.log('pagedAlbumIds', pagedAlbumIds, '\ntagOperator', tagOperator, '\nselectedTags', selectedTags);
        this.getSearchUrl(component, pagedAlbumIds, tagOperator, selectedTags, $A.getCallback(function(searchUrl) {
            component.set('v.searchUrl', searchUrl);
            //component.set('v.showResultsPanel', true);
            console.log('Got searchUrl !', component.get('v.searchUrl'));
        }));
    },
    showToast : function(title, message) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message
            });
            toastEvent.fire();
        } else {
            // fallback if within VF mode
            alert(title + ': ' + message);
        }
    }
})
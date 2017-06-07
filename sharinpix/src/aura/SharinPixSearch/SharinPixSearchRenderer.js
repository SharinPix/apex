({
    render : function(cmp, helper) {
        var superRender = this.superRender();
        var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
        var eventer = window[eventMethod];
        var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";
        var eventListener = function(e) {
            if (e.origin !== "https://app.sharinpix.com" && e.origin !== "https://scpix-pr-1324.herokuapp.com") { return; }
            if (e.data.name == 'search-ready') {
                cmp.set('v.searchReady', true);
            }
        };
        cmp.set('v.eventListener', eventListener);
        eventer(messageEvent, eventListener, false);
        return superRender;
    }/*,
    // Remove event where ? unrender ? onbeforeunload ?
    unrender: function(cmp) {
        this.superUnrender();
        var eventMethod = window.removeEventListener ? "removeEventListener" : "detachEvent";
        var eventer = window[eventMethod];
        var messageEvent = eventMethod == "detachEvent" ? "onmessage" : "message";
        var eventListener = cmp.get('v.eventListener');
        if (!$A.util.isEmpty(eventListener)) {
            eventer(messageEvent, eventListener, false);
        }
    }*/
})
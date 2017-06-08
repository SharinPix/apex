({
    render : function(cmp, helper) {
        var superRender = this.superRender();
        var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
        var eventer = window[eventMethod];
        var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";
        var eventListener = function(e) {
            if (e.origin !== "https://app.sharinpix.com") { return; }
            if (e.data.name == 'search-ready') {
                cmp.set('v.searchReady', true);
                var exEventListener = cmp.get('v.eventListener');
                if (!$A.util.isEmpty(exEventListener)) {
                    var removeEventMethod = window.removeEventListener ? "removeEventListener" : "detachEvent";
                    var eventRemover = window[removeEventMethod];
                    var removeMessageEvent = removeEventMethod == "detachEvent" ? "onmessage" : "message";
                    eventRemover(removeMessageEvent, exEventListener, false);
                }
            }
        };
        cmp.set('v.eventListener', eventListener);
        eventer(messageEvent, eventListener, false);
        return superRender;
    }
})
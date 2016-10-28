({
    MAX_FILE_SIZE: 4 500 000, // 6 000 000 * 3/4 to account for base64
    //CHUNK_SIZE: 950 000, // Use a multiple of 4
    CHUNK_SIZE: 500 000,
    filetoBase64 : function(file, callback){
        var fr = new FileReader();
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            $A.getCallback(function(){
                callback(null, fileContents);
            })();
        }
        fr.readAsDataURL(file);
    },
    update_progress:  function(component){
        component.set('v.progress', 30 + Math.round(component.get('v.n_uploaded')/component.get('v.n_uploading')*70));
    },
    upload: function(component, files, callback) {
        var helper = this;
        for (var i=0; i < files.length; i++) {
            component.set('v.n_uploading', component.get('v.n_uploading') + 1);
            helper.update_progress(component);
            this.upload_file(component, files[i], function(err, res){
                console.log('UPLOADED !' + err + res);
                component.set('v.n_uploaded', component.get('v.n_uploaded') + 1);
                helper.update_progress(component);
                if(component.get('v.n_uploaded') == component.get('v.n_uploading')){
                    callback(null, component.set('v.n_uploaded'));
                    component.set('v.n_uploaded', 0);
                    component.set('v.n_uploading', 0);
                    component.set('v.progress', 0);
                    component.set('v.done', true);
                    /*setTimeout(function(){
                        $A.getCallback(function(){
                            component.set('v.done', false);
                        })();
                     }, 5000);*/
                    var input = component.find("file").getElement();
                    input.type = '';
                    input.type = 'file';
                }
            })
        }
    },
    upload_file: function(component, file, callback) {
        if (file.size > this.MAX_FILE_SIZE) {
            return callback('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
              'Selected file size: ' + file.size, null);
        }
        var self = this;
        this.filetoBase64(file, function(err, content){
            self.uploadChunk(component, file, content, 0, callback);
        });
    },
     
    uploadChunk : function(component, file, fileContents, fromPos, callback, attachId) {
        if (fromPos == fileContents.length) {
            return callback(null, attachId);
        }
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        var chunk = fileContents.substring(fromPos, toPos);
        
        var action = component.get("c.saveTheChunk");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        });
       
        var self = this;
        action.setCallback(this, function(response) {
            console.log('callback');
            if (response.getState() === 'SUCCESS') {
                attachId = response.getReturnValue();
                self.uploadChunk(component, file, fileContents, toPos, callback, attachId);
            }else{
                callback(JSON.stringify(response.getError()), null);
            }
        });

        $A.enqueueAction(action);
    }
})//
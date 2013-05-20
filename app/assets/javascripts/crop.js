(function () {
    namespace("soccer");
    soccer.image_crop = (function (options) {

        var _options = {};

        // convert bytes into friendly format
        var _bytesToSize = function(bytes) {
            var sizes = ['Bytes', 'KB', 'MB'];
            if (bytes == 0) return 'n/a';
            var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
            return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
        };

        // check for selected crop region
        var _checkForm = function() {
            if (parseInt($('#' + _options.modelName + '_crop_w').val())) return true;
            $('.error').html('Please select a crop region and then press Upload').show();
            return false;
        };

        // update info by cropping (onChange and onSelect events handler)
        var _updateInfo = function(e) {
            $('#' + _options.modelName + '_crop_x').val(e.x);
            $('#' + _options.modelName + '_crop_y').val(e.y);
            $('#' + _options.modelName + '_crop_w').val(e.w);
            $('#' + _options.modelName + '_crop_h').val(e.h);
        };

        var _fileSelectHandler = function() {

            // get selected file
            var oFile = _options.fileSelect[0].files[0];

            // hide all errors
            $('.error').hide();

            // check for image type (jpg and png are allowed)
            var rFilter = /^(image\/jpeg|image\/png)$/i;
            if (! rFilter.test(oFile.type)) {
                $('.error').html('Please select a valid image file (jpg and png are allowed)').show();
                return;
            }

            // check for file size
            if (oFile.size > 250 * 1024) {
                $('.error').html('You have selected too big file, please select a one smaller image file').show();
                return;
            }

            // preview element
            var oImage = document.getElementById('preview');

            // prepare HTML5 FileReader
            var oReader = new FileReader();
            oReader.onload = function(e) {

                // e.target.result contains the DataURL which we can use as a source of the image
                oImage.src = e.target.result;
                oImage.onload = function () { // onload event handler

                    // Create variables (in this scope) to hold the Jcrop API and image size
                    var jcrop_api;

                    // destroy Jcrop if it is existed
                    if (typeof jcrop_api != 'undefined')
                        jcrop_api.destroy();

                    // initialize Jcrop
                    $('#preview').Jcrop({
                        minSize: _options.minSize, // min crop size
                        aspectRatio : _options.aspectRatio, // keep aspect ratio 1:1
                        bgFade: true, // use fade effect
                        bgOpacity: .3, // fade opacity
                        onChange: _updateInfo,
                        onSelect: _updateInfo
                    }, function(){

                        // Store the Jcrop API in the jcrop_api variable
                        jcrop_api = this;
                    });
                };
            };

            // read selected file as DataURL
            oReader.readAsDataURL(oFile);
        };

        var init = function(options) {
            _options = options;

            // Attach form handler
            _options.fileSelect.change(_fileSelectHandler);
            _options.form.submit(_checkForm);
        };

        return {
            init:init
        };

    }());
}());
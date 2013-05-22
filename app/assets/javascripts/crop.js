(function () {
    namespace("soccer");
    soccer.image_crop = (function (options) {

        var _options = {};
        var _fileSelected = false;
        var _jcrop_api;
        var _cropBoxWidth;
        var _cropBoxHeight;

        // convert bytes into friendly format
        var _bytesToSize = function(bytes) {
            var sizes = ['Bytes', 'KB', 'MB'];
            if (bytes == 0) return 'n/a';
            var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
            return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
        };

        // check for selected crop region
        var _checkForm = function() {
            if (!_fileSelected || parseInt($('#' + _options.modelName + '_crop_w').val())) return true;
            $('.error').html('Please crop the image').show();
            return false;
        };

        // update info by cropping (onChange and onSelect events handler)
        var _updateInfo = function(e) {
            $('#' + _options.modelName + '_crop_x').val(e.x);
            $('#' + _options.modelName + '_crop_y').val(e.y);
            $('#' + _options.modelName + '_crop_w').val(e.w);
            $('#' + _options.modelName + '_crop_h').val(e.h);

            var widthFactor = _options.minSize[0]/ e.w;
            var heightFactor = _options.minSize[1]/ e.h;

            // update the preview
            $('#crop_preview').css(
                {
                    'width' : Math.round(widthFactor * _cropBoxWidth) + 'px',
                    'height' : Math.round(heightFactor * _cropBoxHeight) + 'px',
                    'marginLeft' : '-' + Math.round(widthFactor * e.x) + 'px',
                    'marginTop' : '-' + Math.round(heightFactor * e.y) + 'px'
                }
            )
        };

        var _showCropPreview = function(src) {

            // cleanup old preview
            var cropPreview = $('#crop_preview');
            if (cropPreview.length != 0) {
                cropPreview.parent().remove();
            }

            var container = _options.fileSelect.parent();

            // Create a preview area
            container.append(
                $('<p>', {class: 'inline-hints'}).append(
                    $('<h4>', {text: 'Preview'}),
                    $('<div>', {style: 'width:'+ _options.minSize[0] + 'px; height:' + _options.minSize[1] + 'px; overflow:hidden'}).append(
                        $('<img>', {id: 'crop_preview', src: src})
                    )
                )
            );

            return $('#crop_preview');
        };

        var _fileSelectHandler = function() {

            _fileSelected = true;

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
            if (oFile.size > 1024 * 1024 * 5) {
                $('.error').html('You have selected too big file, please select a one smaller image file').show();
                return;
            }

            // image element
            var cropbox = $('#cropbox');
            var oImage = cropbox[0];

            // destroy Jcrop if it is existed
            if (typeof _jcrop_api != 'undefined') {
                _jcrop_api.destroy();

                // remove inline styles that jcrop applied
                cropbox.attr('style', '');
            }

            // prepare HTML5 FileReader
            var oReader = new FileReader();
            oReader.onload = function(e) {

                // e.target.result contains the DataURL which we can use as a source of the image
                oImage.src = e.target.result;
                oImage.onload = function () { // onload event handler

                    _cropBoxWidth = cropbox.width();
                    _cropBoxHeight = cropbox.height();

                    // initialize Jcrop
                    cropbox.Jcrop({
                        minSize: _options.minSize, // min crop size
                        aspectRatio : _options.aspectRatio, // keep aspect ratio 1:1
                        bgFade: true, // use fade effect
                        bgOpacity: .3, // fade opacity
                        onChange: _updateInfo,
                        onSelect: _updateInfo
                    }, function(){

                        // Store the Jcrop API in the jcrop_api variable
                        _jcrop_api = this;
                    });

                    // Show the preview for cropping
                    _showCropPreview(this.src);
                };
            };

            // read selected file as DataURL
            oReader.readAsDataURL(oFile);
        };

        var init = function(options) {
            _options = options;
            _options.fileSelect = $('#' + _options.modelName + '_image');
            _options.minSize = [_options.width, _options.height];
            _options.aspectRatio = _options.width / _options.height;

            // Attach form handler
            _options.fileSelect.change(_fileSelectHandler);
            $('form').submit(_checkForm);

        };

        return {
            init:init
        };

    }());
}());
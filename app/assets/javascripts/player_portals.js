// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require jquery
//= require bootstrap-sprockets
//= require jquery.bootstrap.wizard
//= require jquery.validate.min
//= require wizard
//= require jquery.Jcrop.min
//= require namespace

// TODO: Upload birth certificate
// TODO: Upload cropped photo

(function () {
    namespace('player_portal');
    player_portal.image_crop = (function() {
        var CROP_WIDTH = 300;
        var CROP_HEIGHT = 300;
        var _jcrop_api;

        var picture = function(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {

                    // Clean up any old jcrops so the image updates
                    if (_jcrop_api) _jcrop_api.destroy();

                    // Load the image so we can determine it's dimensions
                    var image = new Image();
                    image.src = e.target.result;
                    image.onload = function() {

                        var img_width = this.width;
                        var img_height = this.height;

                        var jcrop_img = $("#jcrop");
                        jcrop_img.attr('src', e.target.result);
                        jcrop_img.Jcrop({
                            onChange: canvas,
                            onSelect: canvas,
                            trueSize: [img_width, img_height],
                            aspectRatio: 1
                        }, function() {

                            x1 = img_width /4;
                            x2 = x1*3;
                            y1 = img_height/4;
                            y2 = y1 * 3;

                            // put the crop box in the center of the image
                            this.setSelect([x1,y1,x2,y2]);
                            _jcrop_api = this;

                            // Turn heading to completed
                            _taskCompleted($('#upload-photo'));
                        });
                    };

                };
                reader.readAsDataURL(input.files[0]);
            }
        };

        var _taskCompleted = function(elem) {

            // Swap the color and the icon
            _swapClass(elem, 'panel-danger', 'panel-success');
            _swapClass(elem.find('.panel-title').find('.glyphicon-alert'), 'glyphicon-alert', 'glyphicon-ok');
        };

        var _swapClass = function(elem, removeClass, addClass) {
            elem.removeClass(removeClass).addClass(addClass);
        };


        var canvas = function (coords){
            var imageObj = $("#jcrop")[0];
            var canvas = $("#canvas")[0];
            canvas.height = canvas.width;   // Keep our aspect ratio
            var context = canvas.getContext("2d");
            context.drawImage(imageObj, coords.x, coords.y, coords.w, coords.h, 0, 0, canvas.width, canvas.height);
            png();
        };

        var png = function () {
            var png = $("#canvas")[0].toDataURL('image/png');
            $("#png").val(png);
        };

        var init = function(defaultImageSrc) {
            $("#wizard-picture").change(function(){
                picture(this);
            });


            // Show default image on the player card
            $("#jcrop")
                .one('load', function() {
                    var canvas = $("#canvas")[0];
                    canvas.height = canvas.width;   // Keep our aspect ratio
                    var context = canvas.getContext("2d");
                    context.drawImage($("#jcrop")[0], 0, 0);
                })
                .attr('src', defaultImageSrc);
        };

        return {
            init:init
        };

    }());
}());


// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require jquery
//= require bootstrap-sprockets
//= require jquery.bootstrap.wizard
//= require jquery.validate.min
//= require wizard
//= require jquery.Jcrop.min
//= require namespace

// TODO: Size picture to fit in the box  Currently 8 pixels too wide
// TODO: Make the preview look a like a player card
// TODO: Upload birth certificate
// TODO: Upload cropped photo

(function () {
    namespace('player_portal');
    player_portal.image_crop = (function() {
        var PREVIEW_WIDTH = 150;
        var PREVIEW_HEIGHT = 150;
        var CROP_WIDTH = 300;
        var CROP_HEIGHT = 300;
        var _jcrop_api;

        var picture = function(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var img = $("#jcrop");
                    img.attr('src', e.target.result);

                    if (_jcrop_api) _jcrop_api.destroy();

                    img.Jcrop({
                        onChange: canvas,
                        onSelect: canvas,
                        minSize: [CROP_WIDTH,CROP_HEIGHT],
                        boxWidth: CROP_WIDTH-8,
                        boxHeight: CROP_HEIGHT,
                        aspectRatio: 1
                    }, function() {
                        this.setSelect([0,0,CROP_WIDTH,CROP_HEIGHT]);
                        _jcrop_api = this;
                    });
                };
                reader.readAsDataURL(input.files[0]);
            }
        };

        var canvas = function (coords){
            var imageObj = $("#jcrop")[0];
            var canvas = $("#canvas")[0];
            canvas.width  = PREVIEW_WIDTH;
            canvas.height = PREVIEW_HEIGHT;
            var context = canvas.getContext("2d");
            context.drawImage(imageObj, coords.x, coords.y, coords.w, coords.h, 0, 0, PREVIEW_WIDTH, PREVIEW_HEIGHT);
            png();
        };

        var png = function () {
            var png = $("#canvas")[0].toDataURL('image/png');
            $("#png").val(png);
        };

        var init = function() {
            $("#wizard-picture").change(function(){
                picture(this);
            });
        };

        return {
            init:init
        };

    }());
}());


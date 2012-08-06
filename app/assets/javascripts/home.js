// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require wowslider
//= require plugins

// wow slider configuration
function ws_fade(slider, el) {
    el.each(function(index) {
        (index == 0 ? $(this).show() : $(this).hide());
    });
    this.go = function(next, current) {
        $(el.get(next)).fadeIn(slider.duration);
        $(el.get(current)).fadeOut(slider.duration);
        return next
    }
};

$("#slider-container").wowSlider(
    {
        effect:"fade",
        prev:"prev",
        next:"next",
        duration:20 * 100,
        delay:20 * 100,
        outWidth:700,
        outHeight:522,
        width:700,
        height:522,
        autoPlay:true,
        stopOnHover:true,
        loop:false,
        bullets:true,
        caption:true,
        controls:true
    }
);


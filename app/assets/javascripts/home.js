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
//function ws_fade(slider, el) {
//    el.each(function(index) {
//        (index == 0 ? $(this).show() : $(this).hide());
//    });
//    this.go = function(next, current) {
//        $(el.get(next)).fadeIn(slider.duration);
//        $(el.get(current)).fadeOut(slider.duration);
//        return next
//    }
//};

//$("#slider-container").wowSlider(
//    {
//        effect:"fade",
//        prev:"prev",
//        next:"next",
//        duration:20 * 100,
//        delay:20 * 100,
//        outWidth:700,
//        outHeight:522,
//        width:700,
//        height:522,
//        autoPlay:true,
//        stopOnHover:true,
//        loop:false,
//        bullets:true,
//        caption:true,
//        controls:true
//    }
//);

function ws_fade(c, a, b) {
    var e = jQuery;
    var d = e("ul", b);
    var f = {position: "absolute",left: 0,top: 0,width: "100%",height: "100%"};
    this.go = function(g, h) {
        var i = e(a.get(g)).clone().css(f).hide().appendTo(b);
        if (!c.noCross) {
            var j = e(a.get(h)).clone().css(f).appendTo(b);
            d.hide();
            j.fadeOut(c.duration, function() {
                j.remove()
            })
        }
        i.fadeIn(c.duration, function() {
            d.css({left: -g + "00%"}).show();
            i.remove()
        });
        return g
    }
}
;

$("#slider-container").wowSlider(
    {
        effect: "fade",
        prev: "Previous",
        next: "Next",
        duration: 20 * 100,
        delay: 20 * 100,
        width: 560,
        height: 420,
        autoPlay: true,
        stopOnHover: true,
        loop: false,
        bullets: true,
        caption: true,
        captionEffect: "fade",
        controls: true,
        onBeforeStep: 0,
        images: 0
    }
);



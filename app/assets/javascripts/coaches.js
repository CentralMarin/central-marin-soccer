// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require plugins
//= require spin
//= require jsrender
//= require jquery.ui.accordion
//= require jquery.simplemodal.1.4.4.min
//= require namespace


(function () {
    namespace("soccer");
    soccer.coaches = function() {

        var _spinner_opts = new Spinner({
            lines: 12, // The number of lines to draw
            length: 21, // The length of each line
            width: 10, // The line thickness
            radius: 31, // The radius of the inner circle
            color: '#000', // #rgb or #rrggbb
            speed: 1.5, // Rounds per second
            trail: 81, // Afterglow percentage
            shadow: true // Whether to render a shadow
        });

        var init = function() {
            $(document).ready(function() {
                $('a[rel]').click(function(event) {

                    var spinner = new Spinner(_spinner_opts).spin($('#record')[0]);

                    var coachId = $(this).data("coachId");
                    $.getJSON('/coaches/' + coachId + '.json', function(coachDetails) {
                        $.modal($("#CoachTemplate").render(coachDetails));
                        spinner.stop();
                    });

                    return false;
                });


                $('#accordion').accordion({ header: "h3"} );
            });
        };

        return {
            init:init
        };
    };
}());

soccer.coaches().init();

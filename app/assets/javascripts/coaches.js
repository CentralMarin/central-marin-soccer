// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require plugins
//= require jsrender
//= require jquery-ui
//= require namespace

(function () {
    namespace("soccer");
    soccer.coaches = function() {

        var init = function() {
            $(document).ready(function() {
                $('a[rel]').click(function(event) {

                    var coachId = $(this).data("coachId");
                    $.getJSON('/coaches/' + coachId + '.json', function(coachDetails) {
                        $( "#coach_dialog" ).dialog({
                            height: 440,
                            width: 600,
                            modal: true,
                            resizable: false,
                            autoOpen: true,
                            draggable: false,
                            closeText: '',
                            show: {
                                effect: "explode",
                                duration: 100
                            }
                        });
                        $("#coach_details").html($("#CoachTemplate").render(coachDetails));
                    });

                    return false;
                });
            });
        };

        return {
            init:init
        };
    }();
}());

soccer.coaches.init();

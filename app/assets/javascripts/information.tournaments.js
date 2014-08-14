//= require jsrender
//= require namespace
//= require jquery-ui/tabs

(function () {
    namespace("soccer.information");

    soccer.information.tournaments = function() {

        var init = function() {
            $(document).ready(function() {
                $("#tabs").tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
                $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
            });
        };

        return {
            init:init
        };
    };
}());

soccer.information.tournaments().init();

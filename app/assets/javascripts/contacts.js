//= require jquery-ui
//= require namespace

(function () {
    namespace("soccer");
    soccer.contacts = function() {

        var init = function(categories) {

            for(var i = 0; i < categories; i++) {
                $( "#accordion" + i ).accordion({
                    collapsible: true,
                    active: false,
                    heightStyle: "content"
                });
            }
        };

        return {
            init:init
        };
    }();
}());


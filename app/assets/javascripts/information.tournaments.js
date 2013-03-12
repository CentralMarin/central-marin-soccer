//= require jquery.simplemodal.1.4.4.min
//= require jsrender
//= require namespace

(function () {
    namespace("soccer.information");

    soccer.information.tournaments = function() {

        var init = function() {
            $(document).ready(function() {
                $("#tabs").tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
                $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );

                $('a[rel]').click(function(event) {
                    var tournament = (this.dataset ? this.dataset['tournament'] : this.getAttribute('data-tournament'));
                    var year = (this.dataset ? this.dataset['year'] : this.getAttribute('data-year'));

                    $.getJSON(document.URL + '/' + tournament + '/' + year + '.json', function(pastWinners) {
                        var modal = $.modal($("#pastWinnersTemplate").render(pastWinners));

                        if (soccer.inline_editing)
                            soccer.inline_editing().enable($('#simplemodal')[0]);
                    });

                    return false;
                });
            });
        };

        return {
            init:init
        };
    };
}());

soccer.information.tournaments().init();

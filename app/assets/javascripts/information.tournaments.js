//= require jquery.simplemodal.1.4.4.min
//= require jsrender

$(document).ready(function() {
    $("#tabs").tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
    $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );

    $('a[rel]').click(function(event) {
        var tournament = event.currentTarget.dataset['tournament'];
        var year = event.currentTarget.dataset['year'];
        $.getJSON(document.URL + '/' + tournament + '/' + year + '.json', function(pastWinners) {
            var modal = $.modal($("#pastWinnersTemplate").render(pastWinners));

            soccer.inline_editing().enable($('#simplemodal')[0]);
        });

        return false;
    });

});


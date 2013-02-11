$(document).ready(function() {
    $("#premier_challenge_winners").accordion({
        heightStyle: "content"
    });
    $("#mission_bell_winners").accordion({
        heightStyle: "content"
    });

    $("#tabs").tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
    $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );

});


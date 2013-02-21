//= require spin

$(document).ready(function() {

    var spinner_opts = {
        lines: 9, // The number of lines to draw
        length: 5, // The length of each line
        width: 4, // The line thickness
        radius: 5, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        color: '#fff', // #rgb or #rrggbb
        speed: 1, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 'auto', // Top position relative to parent in px
        left: 'auto' // Left position relative to parent in px
    };
    var record_spinner = new Spinner(spinner_opts).spin($('#record')[0]);
    var schedule_spinner = new Spinner(spinner_opts).spin($('#schedule')[0]);
    var roster_spinner = new Spinner(spinner_opts).spin($('#roster')[0]);

    $.getJSON(document.url + '/schedule.json', function(schedule) {
        var events = [];
        events.push('<thead><tr><th width="70%" align="left">Name</th><th width="10%" align="center">Date</th><th align="center">Time</th></tr></thead>')
        if (schedule.length == 0) {
            events.push('<tr><td colspan="3">No upcoming events</td></tr>')
        } else {
            $.each(schedule, function(index, event) {
                events.push('<tr><td>' + event.name + '</td><td nowrap>' + event.date + '</td><td nowrap>' + event.start + (event.end ? ' - ' + event.end : '') + '</td></tr>');
            });
        }
        $('<table/>', {
            html: events.join(''),
            style: 'color: white; font-size: 14px;'
        }).appendTo('#schedule');
        schedule_spinner.stop();
    });

    $.getJSON(document.url + '/roster.json', function(roster) {
        var players = [];
        $.each(roster, function(index, player) {
            players.push('<li>' + player.first + ' ' + player.last + '</li>');
        });
        $('<ul/>', {
            html: players.join('')
        }).appendTo('#roster');
        roster_spinner.stop();
    });

    $.getJSON(document.url + '/record.json', function(result) {
        $('#record').append(result.record);
        record_spinner.stop();
    });
});

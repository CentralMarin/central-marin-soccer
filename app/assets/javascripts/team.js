//= require coaches
//= require namespace
//= require jquery.ui.progressbar

(function () {
    namespace("soccer");
    soccer.team = function() {

        var _schedule = function(schedule) {
            var events = [];
            events.push('<thead><tr><th width="70%" align="left">Name</th><th width="10%" align="center">Date</th><th align="center">Time</th></tr></thead>')
            if (schedule == null || schedule.length == 0 || schedule.length == 1 && schedule[0].error != 'undefined') {
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
        };

        var _roster = function(players, managers) {
            var playersHTML = [];
            var managersHTML = [];
            if (players == null) {
                playersHTML.push('<li>Not currently listed</li>');
            } else if (players.length == 1 && players[0].error != 'undefined') {
                playersHTML.push('<li>' + players[0].error + '</li>');
            } else {
                $.each(players, function(index, player) {
                    playersHTML.push('<li>' + player.first + ' ' + player.last + '</li>');
                });
                $.each(managers, function(index, manager) {
                    managersHTML.push(manager.first + ' ' + manager.last);
                });
            }
            $('<ul/>', {
                html: playersHTML.join('')
            }).appendTo('#roster');

            $('#managers').append(managersHTML.join('<br/>'));
        };

        var _record = function(record) {
            $('#record').append(record);
        };

        var init = function() {
            $(document).ready(function() {

                $( "#schedule_progress" ).progressbar({ value: false });
                $( "#roster_progress" ).progressbar({ value: false });

                $.getJSON(document.URL + '/teamsnap.json', function(teamsnap) {
                    if ($.isEmptyObject(teamsnap)) {
                        // provide defaults
                        teamsnap = {schedule: null, players: null, managers: null, record: null}
                    }

                    _schedule(teamsnap.schedule);
                    _roster(teamsnap.players, teamsnap.managers);
                    _record(teamsnap.record);

                    $( "#roster_progress").hide();
                    $( "#schedule_progress").hide();
                });
            });
        };

        return {
            init:init
        };
    };
}());

soccer.team().init();

// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.tools.min.js
//= require plugins
//= require spin
//= require jsrender


    var spinner = new Spinner({
        lines: 12, // The number of lines to draw
        length: 21, // The length of each line
        width: 10, // The line thickness
        radius: 31, // The radius of the inner circle
        color: '#000', // #rgb or #rrggbb
        speed: 1.5, // Rounds per second
        trail: 81, // Afterglow percentage
        shadow: true // Whether to render a shadow
    });

    $('a[rel]').overlay({
        effect: 'apple',
        onBeforeLoad: function(event) {
            var element = event.srcElement;
            while (element.tagName != 'A' && element != null) {
                element = element.parentElement;
            }

            // get the overlay's content div
            var overlay = this.getOverlay();

            // determine if we've already populated the overlay
            //if (overlay.children.length == 0) {

                var coachId = element.dataset['coachId'];

                // build the url with the coach id
                var url = '/coaches/' + coachId + '.json';

                $.getJSON(url, function(coachDetails) {

                    // get the url for the coach image
                    coachDetails.coachImageUrl = $('#coach-img-' + coachId )[0].src;

                    var content = overlay.find('div.contentWrap');
                    content.html($("#CoachTemplate").render(coachDetails));
                });
            //}
        }
    });

    $('#accordion').accordion();

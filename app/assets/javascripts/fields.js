// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require spin
//= require jsrender
//= require namespace

(function () {
    namespace("soccer");
    soccer.fields = (function () {
        var map = null;
        var fields = {};
        var infowindow = new google.maps.InfoWindow({
            content:"Loading..."
        });

        var myOptions = {
            zoom:12,
            mapTypeId:google.maps.MapTypeId.ROADMAP,
            panControl:false,
            scaleControl:false,
            zoomControlOptions:{
                style:google.maps.ZoomControlStyle.LARGE,
                position:google.maps.ControlPosition.RIGHT_TOP
            },
            streetViewControl:false,
            mapTypeControl:true,
            mapTypeControlOptions:{
                style:google.maps.MapTypeControlStyle.DROPDOWN_MENU
            }
        };

        var _showMarker = function (field, bounds) {
            $(field.node).show('slideUp');
            field.marker.setMap(map);
            bounds.extend(field.marker.position);
        };

        var _hideMarker = function (field) {
            $(field.node).hide('slideUp');
            field.marker.setMap(null);
        };

        var _display_info_window = function (field) {
            var content = [field.name, "<br/>",
                field.club, "<br/><br/>",
            "<a target='_blank' href='http://maps.google.com/maps?saddr=&daddr=" ,encodeURIComponent(field.address),"'>Directions</a>"].join("");
            infowindow.setContent(content);
            infowindow.open(map, field.marker);
        }

        var _addMarker = function (field) {
            var marker = new google.maps.Marker({
                position:new google.maps.LatLng(field.lat, field.lng),
                icon: ["/assets/icons/", field.state, ".png"].join(""),
                animation:google.maps.Animation.DROP,
                title:field.title
            });
            field.marker = marker;

            google.maps.event.addListener(marker, 'click', function () {
                _display_info_window(field);
            });
        };

        var _filterFields = function () {
            var clubName = $("select option:selected").attr('value');
            var stateName = $("input[name=state]:checked").attr('value');

            var bounds = new google.maps.LatLngBounds();

            $.each(fields, function (key, field) {
                ((clubName == 'All' || clubName == field.club) && (stateName == 'All' || stateName == field.state)) ?
                    _showMarker(field, bounds) :
                    _hideMarker(field);
            });

            map.fitBounds(bounds);
        };

        var _showField = function (e) {
            field = fields[$(this).attr("id")];
            _display_info_window(field)
        };

        var init = function (fieldsArray) {

            $('#fields').html($("#CoachTemplate").render(fieldsArray));
            map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

            // Enable UI glitz
            $("#stateFilter").buttonset();

            // associate the backing store with the DOM elements
            var domNodes = $('#fields').children();
            $.each(fieldsArray, function (index, field) {

                _addMarker(this);

                field.node = domNodes[index];
                fields['field' + field.id] = field;
            });

            _filterFields();

            // Hookup filters
            $("#clubFilter").change(_filterFields);
            $("#stateFilter").change(_filterFields);

            // Allow the user to click on a field panel to show it on the map
            $("#fields > li").click(_showField);
        };

        return {
            init:init
        };
    }());
}());

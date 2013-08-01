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
        var _map = null;
        var _fields = {};
        var _infoWindow = null;
        var _googleMapsLoaded = window.google != undefined;

        var _showMarker = function (field, bounds) {
            $(field.node).show('slideUp');
            field.marker.setMap(_map);
            bounds.extend(field.marker.position);
        };

        var _hideMarker = function (field) {
            $(field.node).hide('slideUp');
            field.marker.setMap(null);
        };

        var _streetView = function (field, el) {
            street = new google.maps.StreetViewPanorama(el, {

                position: new google.maps.LatLng(field.lat, field.lng),
                zoomControl: false,
                enableCloseButton: false,
                addressControl: false,
                panControl: false,
                linksControl: false,
                pov: {
                    heading: 0,
                    pitch: 0,
                    zoom: 0
                }
            });
        };

        var _display_info_window = function (field) {
            _infoWindow.setContent($("#InfoWindowTemplate").render(field));

            _infoWindow.open(_map, field.marker);
            google.maps.event.addListener(_infoWindow, 'domready', function() {
                // Add Street View
                _streetView(field, document.getElementById("StreetView"));
            });

        };

        var _addMarker = function (field) {
            var marker = new google.maps.Marker({
                position:new google.maps.LatLng(field.lat, field.lng),
                icon: ["/assets/icons/", field.status_name.toLowerCase(), ".png"].join(""),
                animation:google.maps.Animation.DROP,
                title:field.title
            });
            field.marker = marker;

            google.maps.event.addListener(marker, 'click', function () {
                _display_info_window(field);
            });
        };

        var _filterFields = function () {
            var clubName = $("select option:selected").html() || 'All';
            var statusName = $("input[name=status]:checked").attr('value') || 'All';

            var bounds = new google.maps.LatLngBounds();

            $.each(_fields, function (key, field) {
                ((clubName == 'All' || clubName == field.club) && (statusName == 'All' || statusName == field.status_name)) ?
                    _showMarker(field, bounds) :
                    _hideMarker(field);
            });

            _map.fitBounds(bounds);
        };

        var _showField = function (e) {
            field = _fields[$(this).attr("id")];
            _display_info_window(field)
        };

        var _resizeMap = function () {
            var headerHeight = $('#header')[0].offsetHeight;
            var fieldHeaderHeight = $('#field_header')[0].offsetHeight;
            var footerHeight = $('#footer')[0].offsetHeight;

                $('#map')[0].style.height = _getDocHeight()
                - (headerHeight + fieldHeaderHeight + footerHeight)
                + 'px';
            if (_map != null) {
                google.maps.event.trigger(_map, 'resize');
            }
        };

        var _getDocHeight = function() {
            return Math.max(
              $(window).height(),
              /* For operat */
              document.documentElement.clientHeight
            );
        };

        var init = function (fieldsArray) {

            $('#fields').html($("#FieldTemplate").render(fieldsArray));

            if (_googleMapsLoaded) {
                _infoWindow =new google.maps.InfoWindow({
                    content:"Loading..."
                });
                var mapOptions = {
                    center: new google.maps.LatLng(-34.397, 150.644),
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

                _map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
            }

            // associate the backing store with the DOM elements
            var domNodes = $('#fields').children();
            $.each(fieldsArray, function (index, field) {

                _addMarker(this);

                field.mapUri = "http://maps.google.com/maps?saddr=&daddr=" + encodeURIComponent(field.address);

                field.node = domNodes[index];
                _fields['field' + field.id] = field;
            });

            _filterFields();

            // Enable UI glitz
            $("#statusFilter").buttonset();

            // Hookup filters
            $("#clubFilter").change(_filterFields);
            $("#statusFilter").change(_filterFields);

            // Allow the user to click on a field panel to show it on the map
            $("#fields > li").click(_showField);

            //resize the map container
            _resizeMap();

            // bind resize map function to the resize event for the window
            var resizeTimer = null;
            $(window).resize(function() {
                if (resizeTimer) clearTimeout(resizeTimer);
                resizeTimer = setTimeout(_resizeMap, 100);
            });
        };

        return {
            init:init
        };
    }());
}());


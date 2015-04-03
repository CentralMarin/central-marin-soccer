//= require active_admin/base
//= require active_admin/active_admin_globalize
//= require jquery.multiselect.min
//= require jsrender
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.Jcrop.min
//= require ckeditor/init
//= require namespace
//= require crop
//= require jquery-ui-timepicker-addon
//= require activeadmin-ranked-model

$(document).ready(function() {
    jQuery('input.hasDatetimePicker').datetimepicker({
        dateFormat: "mm/dd/yy",
        timeFormat: "HH:mm",
        hourMin: 9,
        hourMax: 17,
        numberOfMonths: 4,
        stepMinute: 15,
        hourGrid: 1,
        minuteGrid: 15,
        beforeShow: function () {
            setTimeout(
                function () {
                    $('#ui-datepicker-div').css("z-index", "3000");
                }, 100
            );
        }
    });
});
//= require jquery-1.9.0
//= require active_admin/base
//= require active_admin/active_admin_globalize
//= require jquery.multiselect.min
//= require jsrender
//= require jquery-ui
//= require jquery.Jcrop.min
//= require ckeditor/override
//= require ckeditor/init
//= require namespace
//= require crop
//=require jquery-ui-timepicker-addon

$(document).ready(function() {
    jQuery('input.hasDatetimePicker').datetimepicker({
        dateFormat: "yy-mm-dd",
        timeFormat: "hh:mm",
        hourMin: 9,
        hourMax: 17,
        numberOfMonths: 4,
        stepMinute: 15,
        hourGrid: 1,
        minuteGrid: 15,
        parse: 'loose',
        beforeShow: function () {
            setTimeout(
                function () {
                    $('#ui-datepicker-div').css("z-index", "3000");
                }, 100
            );
        }
    });
});
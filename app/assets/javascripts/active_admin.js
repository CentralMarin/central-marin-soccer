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

$(document).ready(function() {

    datetimepicker_func = function(e, elem){
        $('input.hasDatetimePicker').datetimepicker({
            dateFormat: "mm/dd/yy",
            timeFormat: "HH:mm",
            hourMin: 9,
            hourMax: 20,
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
    };

    datetimepicker_func();

    $(document).on('has_many_add:after', '.has_many_container', datetimepicker_func);
});
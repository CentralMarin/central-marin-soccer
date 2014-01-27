// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require namespace

(function () {
    namespace("soccer");
    soccer.registrations = (function () {

        var _current_year = new Date().getFullYear();

        var _default_text = "Select the player's birthday and gender";
        var _tryouts_message = {
            "8B": "Boys and Girls U8, U9<br>Feb 8 9:00-11:00 @ Marin Academy<br>Feb 15th 9:00-11:00 @ Marin Academy",
            "9B": "Boys and Girls U8, U9<br>Feb 8 9:00-11:00 @ Marin Academy<br>Feb 15th 9:00-11:00 @ Marin Academy",
            "8G": "Boys and Girls U8, U9<br>Feb 8 9:00-11:00 @ Marin Academy<br>Feb 15th 9:00-11:00 @ Marin Academy",
            "9G": "Boys and Girls U8, U9<br>Feb 8 9:00-11:00 @ Marin Academy<br>Feb 15th 9:00-11:00 @ Marin Academy",
            "10G": "Girls U10<br>Feb 8 11:00-1:00 @ Marin Academy<br>Feb 15th 11:00-1:00 @ Marin Academy",
            "10B": "Boys U10<br>Feb 9th 9:00-11:00 @ Marin Academy<br>Feb 16th 9:00-11:00 @ Marin Academy",
            "11G": "Girls U11<br>Feb 9th 9:00-11:00 @ Marin Academy<br>Feb 16th 11:00-1:00 @ Marin Academy",
            "11B": "Boys U11<br>Feb 9th 11:00-1:00 @ Marin Academy<br>Feb 16th 11:00-1:00 @ Marin Academy",
            "12B": "Boys and Girls U12-U14<br>The tryouts for U12-U14 boys and girls are in process and we will provide the schedule as soon as possible.",
            "12G": "Boys and Girls U12-U14<br>The tryouts for U12-U14 boys and girls are in process and we will provide the schedule as soon as possible.",
            "13B": "Boys and Girls U12-U14<br>The tryouts for U12-U14 boys and girls are in process and we will provide the schedule as soon as possible.",
            "13G": "Boys and Girls U12-U14<br>The tryouts for U12-U14 boys and girls are in process and we will provide the schedule as soon as possible.",
            "14B": "Boys and Girls U12-U14<br>The tryouts for U12-U14 boys and girls are in process and we will provide the schedule as soon as possible.",
            "14G": "Boys and Girls U12-U14<br>The tryouts for U12-U14 boys and girls are in process and we will provide the schedule as soon as possible.",
            "15G": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "15B": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "16G": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "16B": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "17G": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "17B": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "18G": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "18B": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "19G": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>",
            "19B": "Boys and Girls U15-U19<br>The tryouts for U15-U19 boys and girls will be announced in the spring<br>"
        };

        var _birthdate_changed = function(e) {
            var month = $('#birthdate_month').val();
            var day = $('#birthdate_day').val();
            var year = $('#birthdate_year').val();
            var gender = $('input[name=gender]:checked').val();

            if (month && day && year) {
                // Handle the year rounding based on July 31 cutoff
                var age_level = _current_year - year;
                if (month > 7)
                    age_level--;
                if ($('#play_up').is(':checked'))
                    age_level++;

                var tryout = age_level + gender[0];
                $('input[name=tryout]').val(tryout)
                _set_tryout_text(_tryouts_message[tryout]);
            } else {
                _set_tryout_text(_default_text);
            }
        };

        var _set_tryout_text = function(text) {
            var tryouts_date_and_time = $('#tryouts_date_and_times');
            tryouts_date_and_time.html(text);
        };

        return {
            init_registration: function() {
                // Register change handlers for birthdate
                $('#birthdate_month').change(_birthdate_changed);
                $('#birthdate_day').change(_birthdate_changed);
                $('#birthdate_year').change(_birthdate_changed);
                $('#play_up').change(_birthdate_changed);
                $('input[name=gender]').change(_birthdate_changed);

                _set_tryout_text(_default_text);

                $('input[name=player_first]').focus();
            },

            init_confirmation: function(tryout) {
                $('#tryouts_date_and_times').html(_tryouts_message[tryout]);
            }
        };
    }());
}());

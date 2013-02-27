//= require namespace

(function () {
    namespace("soccer");
    soccer.inline_editing = function() {

        var enable_inline = function(elem) {
            elem.contentEditable = true;

            CKEDITOR.inline(elem, {
                toolbar: null,
                on: {
                    focus: function(event) {
                        // Necessary for hidden dom elements to work properly
                        event.editor.setReadOnly(false);
                    },
                    blur: function(event) {
                        // Grab the name
                        var name = $(elem).data('name');
                        var html = event.editor.getData();

                        var data = {
                            name: name,
                            html: html
                        };

                        // Save the data back to the server
                        $.ajax({
                            type: 'POST',
                            url: '/web_part/save',
                            data: data,
                            beforeSend: function(jqXHR, settings) {
                                jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
                            }
                        })
                            .fail(function(jqXHR, status, error) { alert("Error: " + status + " " + error)});
                    }
                }
            });
        };

        var init = function() {
            $(document).ready(function() {
                $('.editable').each(function(index, elem) {
                    enable_inline(elem);
                });
            });
        };

        return {
            init:init,
            enable: enable_inline
        };
    };
}());

soccer.inline_editing().init();


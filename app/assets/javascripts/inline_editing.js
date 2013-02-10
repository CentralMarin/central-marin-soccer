$(document).ready(function() {
    CKEDITOR.disableAutoInline = true;

    $('.editable').each(function(index, elem) {

        CKEDITOR.inline(elem, {
            toolbar: null,
            readonly: false,
            on: {
                focus: function(event) {
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
    });
});

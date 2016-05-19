function makeid()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

(function () {
    namespace('player_portal');
    player_portal.modalPdf = (function () {

        var init = function () {
            // setup document modal
            $('#documentModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget); // button that triggered the modal
                var title = button.data('title');
                var modal = $(this);
                var document = button.data('document') + '?id=' + makeid();

                // force the browser to reload the pdf by adding a random querystring


                // Set the document links
                var obj = modal.find('.modal-body object');
                obj.attr('data', document);
                obj.find('a').attr('href', document);

                // Set the title
                modal.find('.modal-title').text(title);

                // Set the footer
                modal.find('.modal-footer a').attr('href', document);
            });
        };

        return {
            init: init
        };
    }());

    player_portal.modalImg = (function () {

        var init = function () {
            // setup image modal
            $('#imageModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget); // button that triggered the modal
                var document = button.data('document');
                var title = button.data('title');
                var modal = $(this);

                // Set the title
                modal.find('.modal-title').text(title);

                // Set the document links
                var obj = modal.find('.modal-body img');
                obj.attr('src', document);
            });
        };

        return {
            init: init
        };
    }());
}());
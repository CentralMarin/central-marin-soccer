// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require jquery
//= require bootstrap-sprockets
//= require jquery.bootstrap.wizard
//= require jquery.validate.min
//= require wizard
//= require jquery.Jcrop.min
//= require namespace

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
    player_portal.modalPdf = (function() {

        var init = function() {
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
            init:init
        };
    }());

    player_portal.modalImg = (function() {

        var init = function() {
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
            init:init
        };
    }());

    player_portal.registration_wizard = (function() {
        var CROP_WIDTH = 300;
        var CROP_HEIGHT = 300;
        var _jcrop_api;
        var _success;
        var _errorMsgs;

        var _file_selected = function(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var $input = $(input);
                    $input.siblings('img').attr('src', e.target.result);

                    // Update the heading
                    _taskCompleted($input.closest('.panel'));
                };
                reader.readAsDataURL(input.files[0]);
            }
        };

        // Destroy the current canvas and create a new one
        var _swapCanvas = function() {
            var $canvas = $('#canvas');
            var $parent = $canvas.parent();
            $canvas.remove();

            $('<canvas>').attr({
                id: 'canvas',
                class: 'img-responsive',
                height: 300
            }).appendTo($parent);
        };

        var _picture = function(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {

                    var $input = $(input);
                    var $img = $input.siblings('img');
                    $img.attr('src', e.target.result);

                    // Clean up any old jcrops so the image updates
                    if (_jcrop_api) _jcrop_api.destroy();

                    // Load the image so we can determine it's dimensions
                    var image = new Image();
                    image.src = e.target.result;
                    image.onload = function() {

                        _swapCanvas();

                        var img_width = this.width;
                        var img_height = this.height;

                        $img.Jcrop({
                            onChange: _canvas,
                            onSelect: _canvas,
                            trueSize: [img_width, img_height],
                            aspectRatio: 1
                        }, function() {

                            x1 = img_width /4;
                            x2 = x1*3;
                            y1 = img_height/4;
                            y2 = y1 * 3;

                            // put the crop box in the center of the image
                            this.setSelect([x1,y1,x2,y2]);
                            _jcrop_api = this;

                            // Turn heading to completed
                            _taskCompleted($input.closest('.panel'));
                        });
                    };

                };
                reader.readAsDataURL(input.files[0]);
            }
        };

        var _taskCompleted = function(elem) {

            // Swap the color and the icon
            _swapClass(elem, 'panel-danger', 'panel-success');
            _swapClass(elem.find('.panel-title').find('.glyphicon-alert'), 'glyphicon-alert', 'glyphicon-ok');
        };

        var _swapClass = function(elem, removeClass, addClass) {
            elem.removeClass(removeClass).addClass(addClass);
        };

        var _scrollToTop = function() {
            $('html, body').animate({scrollTop : 0},800);
            return false;
        };

        var _canvas = function (coords){
            var imageObj = $("#jcrop")[0];
            var canvas = $("#canvas")[0];
            canvas.height = canvas.width;   // Keep our aspect ratio
            var context = canvas.getContext("2d");
            if (coords.w == 0 && coords.h == 0) {
                coords.w = CROP_WIDTH;
                coords.h = CROP_HEIGHT;
            }
            context.drawImage(imageObj, coords.x, coords.y, coords.w, coords.h, 0, 0, canvas.width, canvas.height);
            png();
        };

        var png = function () {
            var png = $("#canvas")[0].toDataURL('image/png');
            $("#png").val(png);
        };

        var _toggleVolunteerFee = function(show) {

            var tableShow;
            var tableHide;
            if (show) {
                tableShow = $('#feesWithOptOut');
                tableHide = $('#fees');
            } else {
                tableShow = $('#fees');
                tableHide = $('#feesWithOptOut');
            }

            tableShow.removeClass('hidden');
            tableHide.addClass('hidden');

            var complete = $('#finish');
            complete.data('amount', tableShow.data('amount'));
            complete.data('description', tableShow.data('description'));
        };

        var _submitForm = function(url, formData) {

            var pleaseWait = $('#pleaseWaitDialog');

            // Show the pleaseWaitDialog
            pleaseWait.modal('show');

            $.ajax({
                url: url,
                data: formData,
                contentType: false,
                processData: false,
                type: 'POST'
            })
            .done(function(data) {
                window.location.href = _success + '?success=1';
            })
            .fail(function(data) {
                if (data.status == 402) {
                    var error = JSON.parse(data.responseText).error;

                    // Dismiss the modal and show the error message
                    pleaseWait.modal('hide');

                    _showAlert(error);
                } else {
                    window.alert(_errorMsgs.fiveHundred);
                }
            });
        };

        var _showAlert = function(mesg) {
            var alert = $('#alert');
            alert.find('.message').html(mesg);
            alert.show();
            _scrollToTop();
        };

        var _setupStripe = function(key, success) {

            // Setup Stripe
            var handler = StripeCheckout.configure({
                key: key,
                image: 'https://s3.amazonaws.com/stripe-uploads/acct_17gopvKdw52ZEJhQmerchant-icon-1456253746398-logo.png',
                locale: 'auto',
                token: function(token) {
                    // Due to high fees, we do not accept American Express cards
                    if (token.card.brand == 'American Express') {
                        _showAlert(_errorMsgs.amex);
                        return;
                    }

                    var form = $('#finish').parents('form');
                    var formData = new FormData(form[0]);
                    formData.append('stripeToken', token.id);
                    formData.append('stripeEmail', token.email);

                    _submitForm(form.attr('action'), formData);
                }
            });

            var button = $('#finish');
            button.on('click', function(e) {

                // Check if the user has read the docs
                var volunteer = $('#volunteer');
                if (volunteer.length != 0 && volunteer.find('input:checked').length == 0) {
                    _showAlert(_errorMsgs.docs);
                    return false;
                }

                // Open Checkout with further options
                handler.open({
                    name: 'Central Marin Soccer Club',
                    description: button.data('description'),
                    amount: button.data('amount')
                });
                e.preventDefault();
            });

            // Close Checkout on page navigation
            $(window).on('popstate', function() {
                handler.close();
            });
        };

        var init = function(defaultImageSrc, key, success, hidePayment, errorMsgs) {
            _success = success;
            _errorMsgs = errorMsgs;

            $("#wizard-picture").change(function(){
                _picture(this);
            });

            $("#wizard-birth").change(function() {
                _file_selected(this);
            });

            //Click event to scroll to top
            $('input[name="next"]').click(_scrollToTop);
            $('input[name="previous"]').click(_scrollToTop);

            var $jcrop = $("#jcrop");
            // Show default image on the player card
            $jcrop
                .one('load', function() {
                    var canvas = $("#canvas")[0];
                    canvas.height = canvas.width;   // Keep our aspect ratio
                    var context = canvas.getContext("2d");
                    context.drawImage($jcrop[0], 0, 0);
                })
                .attr('src', defaultImageSrc);

            if (!hidePayment) {

                // volunteer event handler
                var volunteer = $('select[name="volunteer"]');
                volunteer.on('change', function () {
                    _toggleVolunteerFee(this.selectedIndex == 0);
                });
                _toggleVolunteerFee(volunteer[0].selectedIndex == 0);

                _setupStripe(key, success);
            } else {
                var finish = $('#finish');
                finish.on('click', function (e) {
                    var form = finish.parents('form');
                    var formData = new FormData(form[0]);

                    _submitForm(form.attr('action'), formData);
                });
            }
        };

        return {
            init:init
        };

    }());
}());

$("[data-hide]").on("click", function(){
     $(this).closest("." + $(this).attr("data-hide")).hide();
});
(function () {
    namespace('player_portal');

    player_portal.payment = (function() {

        var _scrollToTop = function() {
            $('html, body').animate({scrollTop : 0},800);
            return false;
        };

        var showAlert = function(mesg) {
            var alert = $('#alert');
            alert.find('.message').html(mesg);
            alert.show();
            _scrollToTop();
        };

        var setupStripe = function(key, button, validate, errorMsgs) {

            var _errorMsgs = errorMsgs;
            var _submitForm = function(url, formData) {

                // Show the pleaseWaitDialog
                var pleaseWait = $('#pleaseWaitDialog');
                pleaseWait.modal('show');

                $.ajax({
                    url: url,
                    data: formData,
                    contentType: false,
                    processData: false,
                    type: 'POST'
                })
                    .done(function(data) {
                        window.location.href = url + '?success=1';
                    })
                    .fail(function(data) {
                        // Dismiss the modal and show the error message
                        pleaseWait.modal('hide');

                        if (data.status == 402) {
                            showAlert(JSON.parse(data.responseText).error);
                        } else {
                            showAlert(_errorMsgs.fiveHundred + ': ' + data.responseText);
                        }
                    });
            };

            // Setup Stripe
            var handler = StripeCheckout.configure({
                key: key,
                image: 'https://s3.amazonaws.com/stripe-uploads/acct_17gopvKdw52ZEJhQmerchant-icon-1456253746398-logo.png',
                locale: 'auto',
                token: function(token) {
                    // Due to high fees, we do not accept American Express cards
                    if (token.card.brand == 'American Express') {
                        showAlert(_errorMsgs.amex);
                        return;
                    }

                    var form = button.parents('form');
                    var formData = new FormData(form[0]);
                    formData.append('stripeToken', token.id);
                    formData.append('stripeEmail', token.email);

                    _submitForm(form.attr('action'), formData);
                }
            });

            button.on('click', function(e) {

                if (!validate())
                {
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

        return {
            showAlert: showAlert,
            setupStripe: setupStripe
        }

    }());
}());    
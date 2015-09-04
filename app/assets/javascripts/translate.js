//= require namespace

(function () {
    namespace("soccer");
    soccer.translate = function () {

        // Add the translate button to the tab bar
        var init = function(tabElem, english, spanish) {
            var button = _addTranslateButtonToToolbar(_getTabsToolbar(tabElem));

            button.click(function(event) {
                event.preventDefault();
                _translateContentToSpanish(english, spanish);
            });
        };

        // returns the toolbar element or creates on if one doesn't already exist
        var _getTabsToolbar = function(elem) {
            var spans = elem.getElementsByTagName('span');
            if (spans) {
                return spans[0];
            }

            var span = document.createElement('span');
            span.setAttribute('style', 'position: absolute; right: 5px; top: 10px');
            elem.appendChild(span);

            return span;
        };

        var _addTranslateButtonToToolbar = function(toolbar) {
            var button = document.createElement('a');
            button.setAttribute('href', '#');

            button.innerHTML = "<span class='ui-icon ui-icon-transferthick-e-w' title='Translate to Spanish' />";

            toolbar.appendChild(button);
            return $(button).button();

        };

        // Translate the english text to spanish
        var _translateContentToSpanish = function(elem, es_elem) {
            return $.ajax({
                type: 'POST',
                url: '/web_part/translate',
                data: {html: elem.innerHTML},
                beforeSend: function(jqXHR, settings) {
                    jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
                }
            })
                .done(function(data) {
                    es_elem.innerHTML = data.html;
                })
                .fail(function(jqXHR, status, error) { alert("Error: " + status + " " + error)})
        };

        return {
            init:init
        };
    };
}());

//= require namespace

(function () {
    namespace("soccer");
    soccer.inline_editing = function() {

        var tabsHTML = "<ul><li><a href='#tabs-english'>English</a></li><li><a href='#tabs-spanish'>Spanish</a></li></ul><div id='tabs-spanish'><p>TEST Content - Replace w/ CKEDITOR</p></div>";

        var enable_inline = function(elem) {
            var $elem = $(elem);

            $elem.click(function(event) {
                _addTabs(elem);
                console.log('Focus in');
                event.stopPropagation();
            });

            $elem.focusout(function() {
                //_removeTags(elem);
               console.log('Focus out');
            });
/*
            elem.contentEditable = true;

            CKEDITOR.inline(elem, {
                toolbar: null,
                on: {
                    focus: function(event) {

                        _addTabs(elem);

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
                            .fail(function(jqXHR, status, error) { alert("Error: " + status + " " + error)})
                            .always(function(jqXHR, status, error) { _removeTabs(elem); });
                    }
                }
            });
            */
        };

        var _loadContent = function(locale, name, elem) {
            $.get('/web_part/' + locale, {name: name} )
                .done(function(data) {
                    // Update the element
                    elem.innerHTML = data.html;
                } )
                .fail(function(jqXHR, status, error) { alert("Error: " + status + " " + error)})
        };

        var _addTabs = function(elem, event) {

            // Make sure we only have one set of tabs at a time
            var tabElem = document.getElementById('tabs-english');
            if (tabElem) {
                if (elem != tabElem) {
                    // Remove the other tabs
                    _removeTabs(tabElem);
                } else {
                    return; // Do nothing. Tabs already setup
                }
            }

            var parent = elem.parentNode;
            $(parent).click(function(event) { event.stopPropagation(); });

            var wrapper = document.createElement('div');
            wrapper.setAttribute('id', 'tabs');

            parent.replaceChild(wrapper, elem);
            wrapper.innerHTML = tabsHTML;
            wrapper.appendChild(elem);

            elem.setAttribute('id', 'tabs-english');

            // show tabs
            $( "#tabs" ).tabs();
            
            var webPartName = $(elem).data('name');
            _loadContent('en', webPartName, elem);
            _loadContent('es', webPartName, document.getElementById('tabs-spanish'));
        };

        var _removeTabs = function() {

            // Clean up tabs
            var tabs = document.getElementById('tabs');
            $(tabs).tabs('destroy');

            // Remove wrapper element
            var parent = tabs.parentNode;

            var content = document.getElementById('tabs-english').cloneNode(true);
            content.removeAttribute('id');

            // Add our click handler
            enable_inline(content);

            // Swap elements
            parent.replaceChild(content, tabs);
        };

        var init = function() {
            $(document).ready(function() {
                CKEDITOR.stylesSet.add('CM Styles', [
                    { name: 'Blue Heading', element: 'h2', attributes: { 'class': 'alt' }}
                ]);
                CKEDITOR.config.stylesSet = 'CM Styles';

                $('.editable').each(function(index, elem) {
                    enable_inline(elem);
                });

                $(document).click(function(e) {
                   _removeTabs();
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


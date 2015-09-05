//= require namespace
//= require translate
//= require jsrender

(function () {
    namespace("soccer");
    soccer.inline_editing = function() {

        // Load the HTML template from layouts/application.html.haml
        var tabsHTML = $('#tabsTemplate').render({});

        // Make element clickable for CMS
        var _enable_inline = function(elem) {
            var $elem = $(elem);

            $elem.click(function(event) {
                _addTabs(elem);
                event.stopPropagation();
            });
        };

        // Save both English and Spanish web part content and hide tabs
        var _saveContent = function(name, english_content, spanish_content) {

            return $.ajax({
                type: 'POST',
                url: '/web_part/save',
                data: {name: name, en_html: english_content, es_html: spanish_content},
                beforeSend: function(jqXHR, settings) {
                    jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
                }
            })
            .fail(function(jqXHR, status, error) { alert("Error: " + status + " " + error)})
            .always(function(jqXHR, status, error) { _removeTabs(); });
        };

        // Hide tabs and reload original content
        var _cancelEdit = function(webPartName) {

            _loadContent('en', webPartName, _removeTabs());

        };

        // Load the content for the specified locale
        var _loadContent = function(locale, name, elem) {
            return $.get('/web_part/' + locale, {name: name} )
                .done(function(data) {
                    // Update the element
                    elem.innerHTML = data.html;
                } )
                .fail(function(jqXHR, status, error) { alert("Error: " + status + " " + error)})
        };

        // Show the CKEditor and make the content editable
        var _showCKEditor = function(elem) {
            elem.contentEditable = true;
            CKEDITOR.inline(elem, {
                toolbar: null,
                on: {
                    focus: function(event) {
                        event.editor.setReadOnly(false);
                    }
                }
            });
        };

        // Add Tabs
        var _addTabs = function(elem, event) {

            // Make sure we only have one set of tabs at a time
            var tabElem = document.getElementById('tabs-english');
            if (tabElem) {
               return; // Do nothing. Tabs already setup
            }

            var wrapper = document.createElement('div');
            wrapper.setAttribute('id', 'tabs');

            // Move element under wrapper as the english tab
            elem.parentNode.replaceChild(wrapper, elem);
            wrapper.innerHTML = tabsHTML;
            wrapper.appendChild(elem);
            elem.setAttribute('id', 'tabs-english');

            // Make sure we have the same classes on the spanish tab content
            var es_elem = document.getElementById('tabs-spanish');
            es_elem.setAttribute('class', elem.getAttribute('class'));

            // Show tabs
            $( "#tabs" ).tabs();

            // Reload content to make sure we have the latest
            var webPartName = $(elem).data('name');
            $.when(_loadContent('en', webPartName, elem), _loadContent('es', webPartName, es_elem))
                .done(function() {
                    _showCKEditor(elem);
                    _showCKEditor(es_elem);
                });

            // Toolbar Tab Buttons
            $('#cms-save').button().click(function(event) {
                event.preventDefault();
                _saveContent(webPartName, elem.innerHTML, es_elem.innerHTML);
            });

            $('#cms-cancel').button().click(function(event) {
                event.preventDefault();
                _cancelEdit(webPartName, elem);
            });


            soccer.translate().init(document.getElementById('tabs'), elem, es_elem);
        };

        // Remove the tabs
        var _removeTabs = function() {

            // clean up CKEditors
            for(var instanceName in CKEDITOR.instances) {
                CKEDITOR.instances[instanceName].destroy(true);
            }

            // Clean up tabs
            var tabs = document.getElementById('tabs');
            $(tabs).tabs('destroy');

            // Remove wrapper element
            var parent = tabs.parentNode;

            var content = document.getElementById('tabs-english').cloneNode(true);
            content.removeAttribute('id');
            content.removeAttribute('contenteditable');

            // Add our click handler
            _enable_inline(content);

            // Swap elements
            parent.replaceChild(content, tabs);

            return content;
        };

        // Initialize the CMS
        var init = function() {
            $(document).ready(function() {
                CKEDITOR.stylesSet.add('CM Styles', [
                    { name: 'Blue Heading', element: 'h2', attributes: { 'class': 'alt' }}
                ]);
                CKEDITOR.config.stylesSet = 'CM Styles';

                $('.editable').each(function(index, elem) {
                    _enable_inline(elem);
                });
            });
        };

        return {
            init:init
        };
    };
}());

soccer.inline_editing().init();


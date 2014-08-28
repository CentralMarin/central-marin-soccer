/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	
  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/admin/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/admin/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/admin/ckeditor/attachment_files";
  
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/admin/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/admin/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/admin/ckeditor/pictures";
  
  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/admin/ckeditor/attachment_files";

  // Enable spell checker by default
  config.scayt_autoStartup = true;
  
  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token = jQuery('meta[name=csrf-token]').attr('content'),
        csrf_param = jQuery('meta[name=csrf-param]').attr('content'),
        params = new Object();
    
    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }
    
    return params;
  };
  
  /* Extra plugins */
  // works only with en, ru, uk locales
  config.extraPlugins = "youtube";
  
  /* Toolbars */
  config.toolbar = 'Easy';

  config.toolbar_Easy =
    [
        ['Source','-','Preview'],
        ['Cut','Copy','Paste','PasteText','PasteFromWord'],
        ['Undo','Redo','-','RemoveFormat'],
        [ 'Find','Replace','-','SelectAll','-','Scayt' ],
        ['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Link','Unlink','Anchor'], ['Attachment'], ['Youtube'],
        ['Image', 'Table','HorizontalRule','PageBreak'],
        ['Format']
    ];

    /* allow grid based layout */
    config.extraAllowedContent = 'div(grid_1, grid_2, grid_3, grid_4, grid_5, grid_6, grid_7, grid_8, grid_10, grid_11, grid_12, grid_13, grid_14, grid_15, grid_16, alpha, omega, box, clear)';

};

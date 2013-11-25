/*
 Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config )
{
    // Define changes to default configuration here. For example:
    // config.language = 'fr';
    // config.uiColor = '#AADC6E';
    config.toolbar_blog = [
        { items: ["Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo"]},
        { items: ["Link","Unlink","Anchor"]},
        { items: ["Image","Youtube","Table"]},
        '/',
        { items: [ "Bold","Italic","Underline","Strike"] },
        { items: [ "NumberedList","BulletedList",'-',"Outdent","Indent",'-',"Blockquote",'-',"JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock" ]},
        '/',
        { items: [ "Styles","Format","Font","FontSize"]},
        { items: [ "TextColor","BGColor"]},
        { items: [ "Maximize" ]}

    ];

    config.toolbar_proposal = [
        { items: ["Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo"]},
        { items: ["Link","Unlink","Anchor"]},
        { items: ["Image","Youtube","Table"]},
        { items: [ "Bold","Italic","Underline"]},
        { items: [ "NumberedList","BulletedList",'-',"JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock" ]},
        { items: [ "FontSize"]},
        { items: [ "TextColor","BGColor"]},
        { items: [ "lite_ToggleShow" ]},
        { items: [ "Maximize"]}
    ];

    config.toolbar_forum = [
        { items: ["Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo"]},
        { items: ["Link","Unlink","Anchor"]},
        { items: ["Image","Youtube","Table"]},
        { items: ["Smiley"]},
        '/',
        { items: [ "Bold","Italic","Underline","Strike"] },
        { items: [ "NumberedList","BulletedList",'-',"Outdent","Indent",'-',"Blockquote",'-',"JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock" ]},
        '/',
        { items: [ "Styles","Format","Font","FontSize"]},
        { items: [ "TextColor","BGColor"]},
        { items: [ "Maximize" ]}

    ];

    config.extraPlugins = 'youtube,smiley,wordcount' ;


    /* Filebrowser routes */
    // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
    config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

    // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
    config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

    // The location of a script that handles file uploads in the Flash dialog.
    config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

    // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
    config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

    // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
    config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

    // The location of a script that handles file uploads in the Image dialog.
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";

    // The location of a script that handles file uploads.
    config.filebrowserUploadUrl = "/ckeditor/attachment_files";

    // Rails CSRF token
    config.filebrowserParams = function(){
        var csrf_token, csrf_param, meta,
            metas = document.getElementsByTagName('meta'),
            params = new Object();

        for ( var i = 0 ; i < metas.length ; i++ ){
            meta = metas[i];

            switch(meta.name) {
                case "csrf-token":
                    csrf_token = meta.content;
                    break;
                case "csrf-param":
                    csrf_param = meta.content;
                    break;
                default:
                    continue;
            }
        }

        if (csrf_param !== undefined && csrf_token !== undefined) {
            params[csrf_param] = csrf_token;
        }

        return params;
    };

    config.addQueryString = function( url, params ){
        var queryString = [];

        if ( !params ) {
            return url;
        } else {
            for ( var i in params )
                queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
        }

        return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
    };


    config.wordcount = {
        showWordCount: false,
        showCharCount: false,
        countHTML: false,
        charLimit: 'unlimited',
        wordLimit: 'unlimited'
    };

    // Integrate Rails CSRF token into file upload dialogs (link, image, attachment and flash)
    CKEDITOR.on( 'dialogDefinition', function( ev ){
        // Take the dialog name and its definition from the event data.
        var dialogName = ev.data.name;
        var dialogDefinition = ev.data.definition;
        var content, upload;

        if (CKEDITOR.tools.indexOf(['link', 'image', 'attachment', 'flash'], dialogName) > -1) {
            content = (dialogDefinition.getContents('Upload') || dialogDefinition.getContents('upload'));
            upload = (content == null ? null : content.get('upload'));

            if (upload && upload.filebrowser && upload.filebrowser['params'] === undefined) {
                upload.filebrowser['params'] = config.filebrowserParams();
                upload.action = config.addQueryString(upload.action, upload.filebrowser['params']);
            }
        }
    });
};

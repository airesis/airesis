(function (a) {
    a.create("tinymce.plugins.AiresisEmotionsPlugin", {init: function (b, c) {
        b.addCommand("mceAiresisEmotion", function () {
            b.windowManager.open({file: c + "/emotions.htm", width: 250 + parseInt(b.getLang("emotions.delta_width", 0)), height: 160 + parseInt(b.getLang("emotions.delta_height", 0)), inline: 1}, {plugin_url: c})
        });
        b.addButton("airesis_emotions", {title: "emotions.emotions_desc", cmd: "mceAiresisEmotion", image : c + '/img/smiley-smile.gif'})
    }, getInfo: function () {
        return{longname: "Emotions", author: "Moxiecode Systems AB", authorurl: "http://tinymce.moxiecode.com", infourl: "http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/emotions", version: a.majorVersion + "." + a.minorVersion}
    }});
    a.PluginManager.add("airesis_emotions", a.plugins.AiresisEmotionsPlugin)
})(tinymce);

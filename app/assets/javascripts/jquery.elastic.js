/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <jevin9@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return. Jevin O. Sewaruth
 * ----------------------------------------------------------------------------
 *
 * Autogrow Textarea Plugin Version v3.0
 * http://www.technoreply.com/autogrow-textarea-plugin-3-0
 * 
 * THIS PLUGIN IS DELIVERD ON A PAY WHAT YOU WHANT BASIS. IF THE PLUGIN WAS USEFUL TO YOU, PLEASE CONSIDER BUYING THE PLUGIN HERE :
 * https://sites.fastspring.com/technoreply/instant/autogrowtextareaplugin
 *
 * Date: October 15, 2012
 */
(function($){
    $.fn.elastic = function(){
        return this.each(function(){
            var txtArea = $(this);
            var fakeDiv = $('<div class="autogrow-textarea-mirror"></div>');
            var minHeight = hiddenHeight($(this));
            console.log('minHeight: ' + minHeight);
            txtArea.after(fakeDiv);

            var reloadText = function(event){
                txtArea = $(this);
                fakeDiv = txtArea.next('.autogrow-textarea-mirror');
                fakeDiv.html(stripScripts(txtArea.val().replace(/\n/g, '<br/>') + "<br/>"));
                if (fakeDiv.height() < minHeight) {
                    txtArea.height(minHeight);
                }
                else if(fakeDiv.height() < 10000){
                    txtArea.height(fakeDiv.height());
                }
                else{
                    txtArea.height(10000);
                    txtArea.css({'overflow':'visible'});
                }

            };

            fakeDiv.css({
                "overflow" : "visible",
                "display" : "none",
                "word-wrap":"break-word",
                "padding" : txtArea.css('padding'),
                "width": txtArea.css('width'),
                "font-family": txtArea.css('font-family'),
                "font-size" : txtArea.css('font-size'),
                "line-height": txtArea.css('line-height')
            });

            // Style the textarea
            txtArea.css({"overflow" : "hidden"});
            //txtArea.css({"min-height" : this.rows+"em"});
            txtArea.keyup(reloadText);
        });
    }
})(jQuery);


function hiddenHeight(element) {
    // try to grab the height of the elem
    if (element.height() > 0) {
        return element.height();

// if height is zero, then we're dealing with a hidden element
    } else {
        var copied_elem = element.clone()
            .attr("id", false)
            .css({visibility:"hidden", display:"block",
                position:"absolute"});
        $("body").append(copied_elem);
        var h = copied_elem.height();
        copied_elem.remove();
        return h;
    }
}


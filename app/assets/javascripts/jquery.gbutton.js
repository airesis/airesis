/** CTooltip
 * Version 0.1
 * www.airesis.it
 * Lincensed under GPL
 * @author Rodi Alessandro
 */
(function ($) {
    $.fn.extend({
        gbutton: function (options) {
            if ($(this).hasClass('btn')) {
                if (options && options.icons && options.icons.primary) {
                    var class_ = options.icons.primary;
                    if ($('.ui-icon', this).length == 0) {
                        $(this).html($('<span class="text">').html($(this).html()));
                        $(this).prepend($('<span class="ui-button-icon-primary ui-icon">').addClass(class_));

                    }
                }
            }
            else {
                $(this).button(options);
            }

        }
    });

})(jQuery);

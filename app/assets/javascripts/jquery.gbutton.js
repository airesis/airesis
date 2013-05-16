/** CTooltip
 * Version 0.1
 * www.airesis.it
 * Lincensed under GPL
 * @author Rodi Alessandro
 */
(function ($) {
    $.fn.extend({
        gbutton: function (options) {
            $.each(this, function (i, nome) {
                if ($(this).hasClass('btn')) {
                    if (options && options.icons && options.icons.primary) {
                        var class_ = options.icons.primary;
                        if ($('.ui-icon', this).length == 0) {
                            if (!$(this).is(':empty')) {
                                $(this).html($('<span class="text"></span>').html($(this).html()));
                                $(this).prepend($('<span class="ui-button-icon-primary ui-icon"></span>').addClass(class_));
                            }
                        }
                    }
                }
                else {
                    $(this).button(options);
                }
            });
        }
    });

})(jQuery);

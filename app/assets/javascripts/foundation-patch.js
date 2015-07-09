//open canvas even if button is not included
;
(function ($, window, document, undefined) {
    'use strict';

    Foundation.libs.offcanvas = {
        name: 'offcanvas',

        version: '5.1.1',

        settings: {},

        init: function (scope, method, options) {
            this.events();
        },

        events: function () {
            var S = this.S;

            S(this.scope).off('.offcanvas')
                .on('click.fndtn.offcanvas', '.left-off-canvas-toggle', function (e) {
                    e.preventDefault();
                    S('.off-canvas-wrap').toggleClass('move-right');
                })
                .on('click.fndtn.offcanvas', '.exit-off-canvas', function (e) {
                    e.preventDefault();
                    S(".off-canvas-wrap").removeClass("move-right");
                })
                .on('click.fndtn.offcanvas', '.right-off-canvas-toggle', function (e) {
                    e.preventDefault();
                    S(this).closest(".off-canvas-wrap").toggleClass("move-left");
                })
                .on('click.fndtn.offcanvas', '.exit-off-canvas', function (e) {
                    e.preventDefault();
                    S(".off-canvas-wrap").removeClass("move-left");
                });
        },

        reflow: function () {
        }
    };
}(jQuery, this, this.document));

//dropdown patch
;
(function ($, window, document, undefined) {
    'use strict';

    Foundation.libs.dropdown = {
        name: 'dropdown',

        version: '{{VERSION}}',

        settings: {
            active_class: 'open',
            disabled_class: 'disabled',
            mega_class: 'mega',
            align: 'bottom',
            is_hover: false,
            opened: function () {
            },
            closed: function () {
            }
        },

        init: function (scope, method, options) {
            Foundation.inherit(this, 'throttle');
            this.bindings(method, options);
        },

        events: function (scope) {
            var self = this,
                S = self.S;

            S(this.scope)
                .off('.dropdown')
                .on('click.fndtn.dropdown', '[' + this.attr_name() + ']', function (e) {
                    var settings = S(this).data(self.attr_name(true) + '-init') || self.settings;
                    if (!settings.is_hover || Modernizr.touch) {
                        e.preventDefault();
                        self.toggle($(this));
                    }
                })
                .on('mouseenter.fndtn.dropdown', '[' + this.attr_name() + '], [' + this.attr_name() + '-content]', function (e) {
                    var $this = S(this),
                        dropdown,
                        target;

                    clearTimeout(self.timeout);

                    if ($this.data(self.data_attr())) {
                        dropdown = S('#' + $this.data(self.data_attr()));
                        target = $this;
                    } else {
                        dropdown = $this;
                        target = S("[" + self.attr_name() + "='" + dropdown.attr('id') + "']");
                    }

                    var settings = target.data(self.attr_name(true) + '-init') || self.settings;

                    if (S(e.currentTarget).data(self.data_attr()) && settings.is_hover) {
                        self.closeall.call(self);
                    }

                    if (settings.is_hover) self.open.apply(self, [dropdown, target]);
                })
                .on('mouseleave.fndtn.dropdown', '[' + this.attr_name() + '], [' + this.attr_name() + '-content]', function (e) {
                    var $this = S(this);
                    self.timeout = setTimeout(function () {
                        if ($this.data(self.data_attr())) {
                            var settings = $this.data(self.data_attr(true) + '-init') || self.settings;
                            if (settings.is_hover) self.close.call(self, S('#' + $this.data(self.data_attr())));
                        } else {
                            var target = S('[' + self.attr_name() + '="' + S(this).attr('id') + '"]'),
                                settings = target.data(self.attr_name(true) + '-init') || self.settings;
                            if (settings.is_hover) self.close.call(self, $this);
                        }
                    }.bind(this), 150);
                })
                .on('click.fndtn.dropdown', function (e) {
                    var parent = S(e.target).closest('[' + self.attr_name() + '-content]');

                    if (S(e.target).closest('[' + self.attr_name() + ']').length > 0) {
                        return;
                    }
                    if (!(S(e.target).data('revealId')) &&
                        (parent.length > 0 && (S(e.target).is('[' + self.attr_name() + '-content]') ||
                        $.contains(parent.first()[0], e.target)))) {
                        e.stopPropagation();
                        return;
                    }

                    self.close.call(self, S('[' + self.attr_name() + '-content]'));
                })
                .on('opened.fndtn.dropdown', '[' + self.attr_name() + '-content]', function () {
                    self.settings.opened.call(this);
                })
                .on('closed.fndtn.dropdown', '[' + self.attr_name() + '-content]', function () {
                    self.settings.closed.call(this);
                });

            S(window)
                .off('.dropdown')
                .on('resize.fndtn.dropdown', self.throttle(function () {
                    self.resize.call(self);
                }, 50));

            this.resize();
        },

        close: function (dropdown) {
            var self = this;
            dropdown.each(function () {
                var original_target = $('[' + self.attr_name() + '=' + dropdown[0].id + ']') || $('aria-controls=' + dropdown[0].id + ']');
                original_target.attr('aria-expanded', "false");
                if (self.S(this).hasClass(self.settings.active_class)) {
                    self.S(this)
                        .css(Foundation.rtl ? 'right' : 'left', '-99999px')
                        .attr('aria-hidden', "true")
                        .removeClass(self.settings.active_class)
                        .prev('[' + self.attr_name() + ']')
                        .removeClass(self.settings.active_class)
                        .removeData('target');

                    self.S(this).trigger('closed').trigger('closed.fndtn.dropdown', [dropdown]);
                }
            });
            dropdown.removeClass("f-open-" + this.attr_name(true));
        },

        closeall: function () {
            var self = this;
            $.each(self.S(".f-open-" + this.attr_name(true)), function () {
                self.close.call(self, self.S(this));
            });
        },

        open: function (dropdown, target) {
            this
                .css(dropdown
                    .addClass(this.settings.active_class), target);
            dropdown.prev('[' + this.attr_name() + ']').addClass(this.settings.active_class);
            dropdown.data('target', target.get(0)).trigger('opened').trigger('opened.fndtn.dropdown', [dropdown, target]);
            dropdown.attr('aria-hidden', 'false');
            target.attr('aria-expanded', 'true');
            dropdown.focus();
            dropdown.addClass("f-open-" + this.attr_name(true));
        },

        data_attr: function () {
            if (this.namespace.length > 0) {
                return this.namespace + '-' + this.name;
            }

            return this.name;
        },

        toggle: function (target) {
            if (target.hasClass(this.settings.disabled_class)) {
                return;
            }
            var dropdown = this.S('#' + target.data(this.data_attr()));
            if (dropdown.length === 0) {
                // No dropdown found, not continuing
                return;
            }

            this.close.call(this, this.S('[' + this.attr_name() + '-content]').not(dropdown));

            if (dropdown.hasClass(this.settings.active_class)) {
                this.close.call(this, dropdown);
                if (dropdown.data('target') !== target.get(0))
                    this.open.call(this, dropdown, target);
            } else {
                this.open.call(this, dropdown, target);
            }
        },

        resize: function () {
            var dropdown = this.S('[' + this.attr_name() + '-content].open'),
                target = this.S("[" + this.attr_name() + "='" + dropdown.attr('id') + "']");

            if (dropdown.length && target.length) {
                this.css(dropdown, target);
            }
        },

        css: function (dropdown, target) {
            var left_offset = Math.max((target.width() - dropdown.width()) / 2, 8),
                settings = target.data(this.attr_name(true) + '-init') || this.settings;

            this.clear_idx();

            if (this.small()) {
                var p = this.dirs.bottom.call(dropdown, target, settings);

                dropdown.attr('style', '').removeClass('drop-left drop-right drop-top').css({
                    position: 'absolute',
                    width: '95%',
                    'max-width': 'none',
                    top: p.top
                });

                dropdown.css(Foundation.rtl ? 'right' : 'left', left_offset);
            } else {

                this.style(dropdown, target, settings);
            }

            return dropdown;
        },

        style: function (dropdown, target, settings) {
            var css = $.extend({position: 'absolute'},
                this.dirs[settings.align].call(dropdown, target, settings));

            dropdown.attr('style', '').css(css);
        },

        // return CSS property object
        // `this` is the dropdown
        dirs: {
            // Calculate target offset
            _base: function (t) {
                var o_p = this.offsetParent(),
                    o = o_p.offset(),
                    p = t.offset();

                p.top -= o.top;
                p.left -= o.left;

                //set some flags on the p object to pass along
                p.missRight = false;
                p.missTop = false;
                p.missLeft = false;
                p.leftRightFlag = false;

                //lets see if the panel will be off the screen
                //get the actual width of the page and store it
                var actualBodyWidth = window.outerWidth;
                var actualMarginWidth = (window.outerWidth - actualBodyWidth) / 2;
                var actualBoundary = actualBodyWidth;

                if (!this.hasClass("mega")) {
                    //miss top
                    if (t.offset().top <= this.outerHeight()) {
                        p.missTop = true;
                        actualBoundary = window.outerWidth - actualMarginWidth;
                        p.leftRightFlag = true;
                    }
                    //miss right
                    if (t.offset().left + this.outerWidth() > t.offset().left + actualMarginWidth && t.offset().left - actualMarginWidth > this.outerWidth()) {
                        p.missRight = true;
                        p.missLeft = false;
                    }

                    //miss left
                    if (t.offset().left - this.outerWidth() <= 0) {
                        p.missLeft = true;
                        p.missRight = false;
                    }
                }

                return p;
            },
            top: function (t, s) {
                var self = Foundation.libs.dropdown,
                    p = self.dirs._base.call(this, t);

                this.addClass('drop-top');

                if (p.missTop == true) {
                    p.top = p.top + t.outerHeight() + this.outerHeight();
                    this.removeClass('drop-top');
                }

                if (p.missRight == true) {
                    p.left = p.left - this.outerWidth() + t.outerWidth();
                }

                if (t.outerWidth() < this.outerWidth() || self.small() || this.hasClass(s.mega_menu)) {
                    self.adjust_pip(this, t, s, p);
                }

                if (Foundation.rtl) {
                    return {
                        left: p.left - this.outerWidth() + t.outerWidth(),
                        top: p.top - this.outerHeight()
                    };
                }

                return {left: p.left, top: p.top - this.outerHeight()};
            },
            bottom: function (t, s) {

                var self = Foundation.libs.dropdown,
                    p = self.dirs._base.call(this, t);

                if (p.missRight == true) {
                    p.left = p.left - this.outerWidth() + t.outerWidth();
                }

                if (t.outerWidth() < this.outerWidth() || self.small() || this.hasClass(s.mega_menu)) {
                    self.adjust_pip(this, t, s, p);
                }

                if (self.rtl) {
                    return {left: p.left - this.outerWidth() + t.outerWidth(), top: p.top + t.outerHeight()};
                }

                return {left: p.left, top: p.top + t.outerHeight()};
            },
            left: function (t, s) {
                var p = Foundation.libs.dropdown.dirs._base.call(this, t);

                this.addClass('drop-left');

                if (p.missLeft == true) {
                    p.left = p.left + this.outerWidth();
                    p.top = p.top + t.outerHeight();
                    this.removeClass('drop-left');
                }

                return {left: p.left - this.outerWidth(), top: p.top};
            },
            right: function (t, s) {
                var p = Foundation.libs.dropdown.dirs._base.call(this, t);

                this.addClass('drop-right');

                if (p.missRight == true) {
                    p.left = p.left - this.outerWidth();
                    p.top = p.top + t.outerHeight();
                    this.removeClass('drop-right');
                } else {
                    p.triggeredRight = true;
                }

                var self = Foundation.libs.dropdown;
                if (t.outerWidth() < this.outerWidth() || self.small() || this.hasClass(s.mega_menu)) {
                    self.adjust_pip(this, t, s, p);
                }

                return {left: p.left + t.outerWidth(), top: p.top};
            }
        },

        // Insert rule to style psuedo elements
        adjust_pip: function (dropdown, target, settings, position) {
            var sheet = Foundation.stylesheet,
                pip_offset_base = 8;

            if (dropdown.hasClass(settings.mega_class)) {
                pip_offset_base = position.left + (target.outerWidth() / 2) - 8;
            }
            else if (this.small()) {
                pip_offset_base += position.left - 8;
            }

            this.rule_idx = sheet.cssRules.length;

            //default
            var sel_before = '.f-dropdown.open:before',
                sel_after = '.f-dropdown.open:after',
                css_before = 'left: ' + pip_offset_base + 'px;',
                css_after = 'left: ' + (pip_offset_base - 1) + 'px;';

            if (position.missRight == true) {
                pip_offset_base = dropdown.outerWidth() - 23;
                sel_before = '.f-dropdown.open:before',
                    sel_after = '.f-dropdown.open:after',
                    css_before = 'left: ' + pip_offset_base + 'px;',
                    css_after = 'left: ' + (pip_offset_base - 1) + 'px;';
            }

            //just a case where right is fired, but its not missing right
            if (position.triggeredRight == true) {
                sel_before = '.f-dropdown.open:before',
                    sel_after = '.f-dropdown.open:after',
                    css_before = 'left:-12px;',
                    css_after = 'left:-14px;';
            }

            if (sheet.insertRule) {
                sheet.insertRule([sel_before, '{', css_before, '}'].join(' '), this.rule_idx);
                sheet.insertRule([sel_after, '{', css_after, '}'].join(' '), this.rule_idx + 1);
            } else {
                sheet.addRule(sel_before, css_before, this.rule_idx);
                sheet.addRule(sel_after, css_after, this.rule_idx + 1);
            }
        },

        // Remove old dropdown rule index
        clear_idx: function () {
            var sheet = Foundation.stylesheet;

            if (typeof this.rule_idx !== 'undefined') {
                sheet.deleteRule(this.rule_idx);
                sheet.deleteRule(this.rule_idx);
                delete this.rule_idx;
            }
        },

        small: function () {
            return matchMedia(Foundation.media_queries.small).matches && !matchMedia(Foundation.media_queries.medium).matches;
        },

        off: function () {
            this.S(this.scope).off('.fndtn.dropdown');
            this.S('html, body').off('.fndtn.dropdown');
            this.S(window).off('.fndtn.dropdown');
            this.S('[data-dropdown-content]').off('.fndtn.dropdown');
        },

        reflow: function () {
        }
    };
}(jQuery, window, window.document));


;
(function ($, window, document, undefined) {
    'use strict';

    Foundation.libs.slider = {
        name: 'slider',

        version: '{{VERSION}}',

        settings: {
            start: 0,
            end: 100,
            step: 1,
            precision: null,
            initial: null,
            display_selector: '',
            vertical: false,
            trigger_input_change: false,
            on_change: function () {
            }
        },

        cache: {},

        init: function (scope, method, options) {
            Foundation.inherit(this, 'throttle');
            this.bindings(method, options);
            this.reflow();
        },

        events: function () {
            var self = this;

            $(this.scope)
                .off('.slider')
                .on('mousedown.fndtn.slider touchstart.fndtn.slider pointerdown.fndtn.slider',
                '[' + self.attr_name() + ']:not(.disabled, [disabled]) .range-slider-handle', function (e) {
                    if (!self.cache.active) {
                        e.preventDefault();
                        self.set_active_slider($(e.target));
                    }
                })
                .on('mousemove.fndtn.slider touchmove.fndtn.slider pointermove.fndtn.slider', function (e) {
                    if (!!self.cache.active) {
                        e.preventDefault();
                        if ($.data(self.cache.active[0], 'settings').vertical) {
                            var scroll_offset = 0;
                            if (!e.pageY) {
                                scroll_offset = window.scrollY;
                            }
                            self.calculate_position(self.cache.active, self.get_cursor_position(e, 'y') + scroll_offset);
                        } else {
                            self.calculate_position(self.cache.active, self.get_cursor_position(e, 'x'));
                        }
                    }
                })
                .on('mouseup.fndtn.slider touchend.fndtn.slider pointerup.fndtn.slider', function (e) {
                    self.remove_active_slider();
                })
                .on('change.fndtn.slider', function (e) {
                    self.settings.on_change();
                });

            self.S(window)
                .on('resize.fndtn.slider', self.throttle(function (e) {
                    self.reflow();
                }, 300));

            // update slider value as users change input value
            this.S('[' + this.attr_name() + ']').each(function () {
                var slider = $(this),
                    handle = slider.children('.range-slider-handle')[0],
                    settings = self.initialize_settings(handle);

                if (settings.display_selector != '') {
                    $(settings.display_selector).each(function () {
                        if ($(this).attr('value')) {
                            $(this).off('change').on('change', function () {
                                slider.foundation("slider", "set_value", $(this).val());
                            });
                        }
                    });
                }
            });
        },

        get_cursor_position: function (e, xy) {
            var pageXY = 'page' + xy.toUpperCase(),
                clientXY = 'client' + xy.toUpperCase(),
                position;

            if (typeof e[pageXY] !== 'undefined') {
                position = e[pageXY];
            } else if (typeof e.originalEvent[clientXY] !== 'undefined') {
                position = e.originalEvent[clientXY];
            } else if (e.originalEvent.touches && e.originalEvent.touches[0] && typeof e.originalEvent.touches[0][clientXY] !== 'undefined') {
                position = e.originalEvent.touches[0][clientXY];
            } else if (e.currentPoint && typeof e.currentPoint[xy] !== 'undefined') {
                position = e.currentPoint[xy];
            }

            return position;
        },

        set_active_slider: function ($handle) {
            this.cache.active = $handle;
        },

        remove_active_slider: function () {
            this.cache.active = null;
        },

        calculate_position: function ($handle, cursor_x) {
            var self = this,
                settings = $.data($handle[0], 'settings'),
                handle_l = $.data($handle[0], 'handle_l'),
                handle_o = $.data($handle[0], 'handle_o'),
                bar_l = $.data($handle[0], 'bar_l'),
                bar_o = $.data($handle[0], 'bar_o');

            requestAnimationFrame(function () {
                var pct;

                if (Foundation.rtl && !settings.vertical) {
                    pct = self.limit_to(((bar_o + bar_l - cursor_x) / bar_l), 0, 1);
                } else {
                    pct = self.limit_to(((cursor_x - bar_o) / bar_l), 0, 1);
                }

                pct = settings.vertical ? 1 - pct : pct;

                var norm = self.normalized_value(pct, settings.start, settings.end, settings.step, settings.precision);

                self.set_ui($handle, norm);
            });
        },

        set_ui: function ($handle, value) {
            var settings = $.data($handle[0], 'settings'),
                handle_l = $.data($handle[0], 'handle_l'),
                bar_l = $.data($handle[0], 'bar_l'),
                norm_pct = this.normalized_percentage(value, settings.start, settings.end),
                handle_offset = norm_pct * (bar_l - handle_l) - 1,
                progress_bar_length = norm_pct * 100,
                $handle_parent = $handle.parent(),
                $hidden_inputs = $handle.parent().children('input[type=hidden]');

            if (Foundation.rtl && !settings.vertical) {
                handle_offset = -handle_offset;
            }

            handle_offset = settings.vertical ? -handle_offset + bar_l - handle_l + 1 : handle_offset;
            this.set_translate($handle, handle_offset, settings.vertical);

            if (settings.vertical) {
                $handle.siblings('.range-slider-active-segment').css('height', progress_bar_length + '%');
            } else {
                $handle.siblings('.range-slider-active-segment').css('width', progress_bar_length + '%');
            }

            $handle_parent.attr(this.attr_name(), value).trigger('change.fndtn.slider');

            $hidden_inputs.val(value);
            if (settings.trigger_input_change) {
                $hidden_inputs.trigger('change.fndtn.slider');
            }

            if (!$handle[0].hasAttribute('aria-valuemin')) {
                $handle.attr({
                    'aria-valuemin': settings.start,
                    'aria-valuemax': settings.end
                });
            }
            $handle.attr('aria-valuenow', value);

            if (settings.display_selector != '') {
                $(settings.display_selector).each(function () {
                    if (this.hasAttribute('value')) {
                        $(this).val(value);
                    } else {
                        $(this).text(value);
                    }
                });
            }

        },

        normalized_percentage: function (val, start, end) {
            return Math.min(1, (val - start) / (end - start));
        },

        normalized_value: function (val, start, end, step, precision) {
            var range = end - start,
                point = val * range,
                mod = (point - (point % step)) / step,
                rem = point % step,
                round = ( rem >= step * 0.5 ? step : 0);
            return ((mod * step + round) + start).toFixed(precision);
        },

        set_translate: function (ele, offset, vertical) {
            if (vertical) {
                $(ele)
                    .css('-webkit-transform', 'translateY(' + offset + 'px)')
                    .css('-moz-transform', 'translateY(' + offset + 'px)')
                    .css('-ms-transform', 'translateY(' + offset + 'px)')
                    .css('-o-transform', 'translateY(' + offset + 'px)')
                    .css('transform', 'translateY(' + offset + 'px)');
            } else {
                $(ele)
                    .css('-webkit-transform', 'translateX(' + offset + 'px)')
                    .css('-moz-transform', 'translateX(' + offset + 'px)')
                    .css('-ms-transform', 'translateX(' + offset + 'px)')
                    .css('-o-transform', 'translateX(' + offset + 'px)')
                    .css('transform', 'translateX(' + offset + 'px)');
            }
        },

        limit_to: function (val, min, max) {
            return Math.min(Math.max(val, min), max);
        },

        initialize_settings: function (handle) {
            var settings = $.extend({}, this.settings, this.data_options($(handle).parent())),
                decimal_places_match_result;

            if (settings.precision === null) {
                decimal_places_match_result = ('' + settings.step).match(/\.([\d]*)/);
                settings.precision = decimal_places_match_result && decimal_places_match_result[1] ? decimal_places_match_result[1].length : 0;
            }

            if (settings.vertical) {
                $.data(handle, 'bar_o', $(handle).parent().offset().top);
                $.data(handle, 'bar_l', $(handle).parent().outerHeight());
                $.data(handle, 'handle_o', $(handle).offset().top);
                $.data(handle, 'handle_l', $(handle).outerHeight());
            } else {
                $.data(handle, 'bar_o', $(handle).parent().offset().left);
                $.data(handle, 'bar_l', $(handle).parent().outerWidth());
                $.data(handle, 'handle_o', $(handle).offset().left);
                $.data(handle, 'handle_l', $(handle).outerWidth());
            }

            $.data(handle, 'bar', $(handle).parent());
            return $.data(handle, 'settings', settings);
        },

        set_initial_position: function ($ele) {
            var settings = $.data($ele.children('.range-slider-handle')[0], 'settings'),
                initial = ((typeof settings.initial == 'number' && !isNaN(settings.initial)) ? settings.initial : Math.floor((settings.end - settings.start) * 0.5 / settings.step) * settings.step + settings.start),
                $handle = $ele.children('.range-slider-handle');
            this.set_ui($handle, initial);
        },

        set_value: function (value) {
            var self = this;
            $('[' + self.attr_name() + ']', this.scope).each(function () {
                $(this).attr(self.attr_name(), value);
            });
            if (!!$(this.scope).attr(self.attr_name())) {
                $(this.scope).attr(self.attr_name(), value);
            }
            self.reflow();
        },

        reflow: function () {
            var self = this;
            self.S('[' + this.attr_name() + ']').each(function () {
                var handle = $(this).children('.range-slider-handle')[0],
                    val = $(this).attr(self.attr_name());
                self.initialize_settings(handle);

                if (val) {
                    self.set_ui($(handle), parseFloat(val));
                } else {
                    self.set_initial_position($(this));
                }
            });
        }
    };

}(jQuery, window, window.document));

//open canvas even if button is not included
;(function ($, window, document, undefined) {
    'use strict';

    Foundation.libs.offcanvas = {
        name : 'offcanvas',

        version : '5.1.1',

        settings : {},

        init : function (scope, method, options) {
            this.events();
        },

        events : function () {
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

        reflow : function () {}
    };
}(jQuery, this, this.document));

//todo to be removed with foundation 5.3. we need this for capybara-webkit tests
;(function ($, window, document, undefined) {
    'use strict';

    Foundation.libs.reveal = {
        name : 'reveal',

        version : '5.2.2',

        locked : false,

        settings : {
            animation: 'fadeAndPop',
            animation_speed: 250,
            close_on_background_click: true,
            close_on_esc: true,
            dismiss_modal_class: 'close-reveal-modal',
            bg_class: 'reveal-modal-bg',
            open: function(){},
            opened: function(){},
            close: function(){},
            closed: function(){},
            bg : $('.reveal-modal-bg'),
            css : {
                open : {
                    'opacity': 0,
                    'visibility': 'visible',
                    'display' : 'block'
                },
                close : {
                    'opacity': 1,
                    'visibility': 'hidden',
                    'display': 'none'
                }
            }
        },

        init : function (scope, method, options) {
            $.extend(true, this.settings, method, options);
            this.bindings(method, options);
        },

        events : function (scope) {
            var self = this,
                S = self.S;

            S(this.scope)
                .off('.reveal')
                .on('click.fndtn.reveal', '[' + this.add_namespace('data-reveal-id') + ']', function (e) {
                    e.preventDefault();

                    if (!self.locked) {
                        var element = S(this),
                            ajax = element.data(self.data_attr('reveal-ajax'));

                        self.locked = true;

                        if (typeof ajax === 'undefined') {
                            self.open.call(self, element);
                        } else {
                            var url = ajax === true ? element.attr('href') : ajax;

                            self.open.call(self, element, {url: url});
                        }
                    }
                });

            S(document)
                .on('touchend.fndtn.reveal click.fndtn.reveal', this.close_targets(), function (e) {

                    e.preventDefault();

                    if (!self.locked) {
                        var settings = S('[' + self.attr_name() + '].open').data(self.attr_name(true) + '-init'),
                            bg_clicked = S(e.target)[0] === S('.' + settings.bg_class)[0];

                        if (bg_clicked) {
                            if (settings.close_on_background_click) {
                                e.stopPropagation();
                            } else {
                                return;
                            }
                        }

                        self.locked = true;
                        self.close.call(self, bg_clicked ? S('[' + self.attr_name() + '].open') : S(this).closest('[' + self.attr_name() + ']'));
                    }
                });

            if(S('[' + self.attr_name() + ']', this.scope).length > 0) {
                S(this.scope)
                    // .off('.reveal')
                    .on('open.fndtn.reveal', this.settings.open)
                    .on('opened.fndtn.reveal', this.settings.opened)
                    .on('opened.fndtn.reveal', this.open_video)
                    .on('close.fndtn.reveal', this.settings.close)
                    .on('closed.fndtn.reveal', this.settings.closed)
                    .on('closed.fndtn.reveal', this.close_video);
            } else {
                S(this.scope)
                    // .off('.reveal')
                    .on('open.fndtn.reveal', '[' + self.attr_name() + ']', this.settings.open)
                    .on('opened.fndtn.reveal', '[' + self.attr_name() + ']', this.settings.opened)
                    .on('opened.fndtn.reveal', '[' + self.attr_name() + ']', this.open_video)
                    .on('close.fndtn.reveal', '[' + self.attr_name() + ']', this.settings.close)
                    .on('closed.fndtn.reveal', '[' + self.attr_name() + ']', this.settings.closed)
                    .on('closed.fndtn.reveal', '[' + self.attr_name() + ']', this.close_video);
            }

            return true;
        },

        // PATCH #3: turning on key up capture only when a reveal window is open
        key_up_on : function (scope) {
            var self = this;

            // PATCH #1: fixing multiple keyup event trigger from single key press
            self.S('body').off('keyup.fndtn.reveal').on('keyup.fndtn.reveal', function ( event ) {
                var open_modal = self.S('[' + self.attr_name() + '].open'),
                    settings = open_modal.data(self.attr_name(true) + '-init');
                // PATCH #2: making sure that the close event can be called only while unlocked,
                //           so that multiple keyup.fndtn.reveal events don't prevent clean closing of the reveal window.
                if ( settings && event.which === 27  && settings.close_on_esc && !self.locked) { // 27 is the keycode for the Escape key
                    self.close.call(self, open_modal);
                }
            });

            return true;
        },

        // PATCH #3: turning on key up capture only when a reveal window is open
        key_up_off : function (scope) {
            this.S('body').off('keyup.fndtn.reveal');
            return true;
        },

        open : function (target, ajax_settings) {
            var self = this;
            if (target) {
                if (typeof target.selector !== 'undefined') {
                    // Find the named node; only use the first one found, since the rest of the code assumes there's only one node
                    var modal = self.S('#' + target.data(self.data_attr('reveal-id'))).first();
                } else {
                    var modal = self.S(this.scope);

                    ajax_settings = target;
                }
            } else {
                var modal = self.S(this.scope);
            }

            var settings = modal.data(self.attr_name(true) + '-init');
            settings = settings || this.settings;

            if (!modal.hasClass('open')) {
                var open_modal = self.S('[' + self.attr_name() + '].open');

                if (typeof modal.data('css-top') === 'undefined') {
                    modal.data('css-top', parseInt(modal.css('top'), 10))
                        .data('offset', this.cache_offset(modal));
                }

                this.key_up_on(modal);    // PATCH #3: turning on key up capture only when a reveal window is open
                modal.trigger('open');

                if (open_modal.length < 1) {
                    this.toggle_bg(modal, true);
                }

                if (typeof ajax_settings === 'string') {
                    ajax_settings = {
                        url: ajax_settings
                    };
                }

                if (typeof ajax_settings === 'undefined' || !ajax_settings.url) {
                    if (open_modal.length > 0) {
                        this.hide(open_modal, settings.css.close);
                    }

                    this.show(modal, settings.css.open);
                } else {
                    var old_success = typeof ajax_settings.success !== 'undefined' ? ajax_settings.success : null;

                    $.extend(ajax_settings, {
                        success: function (data, textStatus, jqXHR) {
                            if ( $.isFunction(old_success) ) {
                                old_success(data, textStatus, jqXHR);
                            }

                            modal.html(data);
                            self.S(modal).foundation('section', 'reflow');
                            self.S(modal).children().foundation();

                            if (open_modal.length > 0) {
                                self.hide(open_modal, settings.css.close);
                            }
                            self.show(modal, settings.css.open);
                        }
                    });

                    $.ajax(ajax_settings);
                }
            }
        },

        close : function (modal) {
            var modal = modal && modal.length ? modal : this.S(this.scope),
                open_modals = this.S('[' + this.attr_name() + '].open'),
                settings = modal.data(this.attr_name(true) + '-init');

            if (open_modals.length > 0) {
                this.locked = true;
                this.key_up_off(modal);   // PATCH #3: turning on key up capture only when a reveal window is open
                modal.trigger('close');
                this.toggle_bg(modal, false);
                this.hide(open_modals, settings.css.close, settings);
            }
        },

        close_targets : function () {
            var base = '.' + this.settings.dismiss_modal_class;

            if (this.settings.close_on_background_click) {
                return base + ', .' + this.settings.bg_class;
            }

            return base;
        },

        toggle_bg : function (modal, state) {
            if (this.S('.' + this.settings.bg_class).length === 0) {
                this.settings.bg = $('<div />', {'class': this.settings.bg_class})
                    .appendTo('body').hide();
            }

            var visible = this.settings.bg.filter(':visible').length > 0;
            if ( state != visible ) {
                if ( state == undefined ? visible : !state ) {
                    this.hide(this.settings.bg);
                } else {
                    this.show(this.settings.bg);
                }
            }
        },

        show : function (el, css) {
            // is modal
            if (css) {
                var settings = el.data(this.attr_name(true) + '-init');
                settings = settings || this.settings;

                if (el.parent('body').length === 0) {
                    var placeholder = el.wrap('<div style="display: none;" />').parent(),
                        rootElement = this.settings.rootElement || 'body';

                    el.on('closed.fndtn.reveal.wrapped', function() {
                        el.detach().appendTo(placeholder);
                        el.unwrap().unbind('closed.fndtn.reveal.wrapped');
                    });

                    el.detach().appendTo(rootElement);
                }

                var animData = getAnimationData(settings.animation);
                if (!animData.animate) {
                    this.locked = false;
                }
                if (animData.pop) {
                    css.top = $(window).scrollTop() - el.data('offset') + 'px';
                    var end_css = {
                        top: $(window).scrollTop() + el.data('css-top') + 'px',
                        opacity: 1
                    };

                    return setTimeout(function () {
                        return el
                            .css(css)
                            .animate(end_css, settings.animation_speed, 'linear', function () {
                                this.locked = false;
                                el.trigger('opened');
                            }.bind(this))
                            .addClass('open');
                    }.bind(this), settings.animation_speed / 2);
                }

                if (animData.fade) {
                    css.top = $(window).scrollTop() + el.data('css-top') + 'px';
                    var end_css = {opacity: 1};

                    return setTimeout(function () {
                        return el
                            .css(css)
                            .animate(end_css, settings.animation_speed, 'linear', function () {
                                this.locked = false;
                                el.trigger('opened');
                            }.bind(this))
                            .addClass('open');
                    }.bind(this), settings.animation_speed / 2);
                }

                return el.css(css).show().css({opacity: 1}).addClass('open').trigger('opened');
            }

            var settings = this.settings;

            // should we animate the background?
            if (getAnimationData(settings.animation).fade) {
                return el.fadeIn(settings.animation_speed / 2);
            }

            this.locked = false;

            return el.show();
        },

        hide : function (el, css) {
            // is modal
            if (css) {
                var settings = el.data(this.attr_name(true) + '-init');
                settings = settings || this.settings;

                var animData = getAnimationData(settings.animation);
                if (!animData.animate) {
                    this.locked = false;
                }
                if (animData.pop) {
                    var end_css = {
                        top: - $(window).scrollTop() - el.data('offset') + 'px',
                        opacity: 0
                    };

                    return setTimeout(function () {
                        return el
                            .animate(end_css, settings.animation_speed, 'linear', function () {
                                this.locked = false;
                                el.css(css).trigger('closed');
                            }.bind(this))
                            .removeClass('open');
                    }.bind(this), settings.animation_speed / 2);
                }

                if (animData.fade) {
                    var end_css = {opacity: 0};

                    return setTimeout(function () {
                        return el
                            .animate(end_css, settings.animation_speed, 'linear', function () {
                                this.locked = false;
                                el.css(css).trigger('closed');
                            }.bind(this))
                            .removeClass('open');
                    }.bind(this), settings.animation_speed / 2);
                }

                return el.hide().css(css).removeClass('open').trigger('closed');
            }

            var settings = this.settings;

            // should we animate the background?
            if (getAnimationData(settings.animation).fade) {
                return el.fadeOut(settings.animation_speed / 2);
            }

            return el.hide();
        },

        close_video : function (e) {
            var video = $('.flex-video', e.target),
                iframe = $('iframe', video);

            if (iframe.length > 0) {
                iframe.attr('data-src', iframe[0].src);
                iframe.attr('src', 'about:blank');
                video.hide();
            }
        },

        open_video : function (e) {
            var video = $('.flex-video', e.target),
                iframe = video.find('iframe');

            if (iframe.length > 0) {
                var data_src = iframe.attr('data-src');
                if (typeof data_src === 'string') {
                    iframe[0].src = iframe.attr('data-src');
                } else {
                    var src = iframe[0].src;
                    iframe[0].src = undefined;
                    iframe[0].src = src;
                }
                video.show();
            }
        },

        data_attr: function (str) {
            if (this.namespace.length > 0) {
                return this.namespace + '-' + str;
            }

            return str;
        },

        cache_offset : function (modal) {
            var offset = modal.show().height() + parseInt(modal.css('top'), 10);

            modal.hide();

            return offset;
        },

        off : function () {
            $(this.scope).off('.fndtn.reveal');
        },

        reflow : function () {}
    };

    /*
     * getAnimationData('popAndFade') // {animate: true,  pop: true,  fade: true}
     * getAnimationData('fade')       // {animate: true,  pop: false, fade: true}
     * getAnimationData('pop')        // {animate: true,  pop: true,  fade: false}
     * getAnimationData('foo')        // {animate: false, pop: false, fade: false}
     * getAnimationData(null)         // {animate: false, pop: false, fade: false}
     */
    function getAnimationData(str) {
        var fade = /fade/i.test(str);
        var pop = /pop/i.test(str);
        return {
            animate: fade || pop,
            pop: pop,
            fade: fade
        };
    }
}(jQuery, window, window.document));





//dropdown patch
;(function ($, window, document, undefined) {
    'use strict';

    Foundation.libs.dropdown = {
        name : 'dropdown',

        version : '{{VERSION}}',

        settings : {
            active_class: 'open',
            disabled_class: 'disabled',
            mega_class: 'mega',
            align: 'bottom',
            is_hover: false,
            opened: function(){},
            closed: function(){}
        },

        init : function (scope, method, options) {
            Foundation.inherit(this, 'throttle');
            this.bindings(method, options);
        },

        events : function (scope) {
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

                    if(S(e.currentTarget).data(self.data_attr()) && settings.is_hover) {
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
                            var target   = S('[' + self.attr_name() + '="' + S(this).attr('id') + '"]'),
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
                var original_target = $('[' + self.attr_name() + '=' + dropdown[0].id + ']') || $('aria-controls=' + dropdown[0].id+ ']');
                original_target.attr('aria-expanded', "false");
                if (self.S(this).hasClass(self.settings.active_class)) {
                    self.S(this)
                        .css(Foundation.rtl ? 'right':'left', '-99999px')
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

        closeall: function() {
            var self = this;
            $.each(self.S(".f-open-" + this.attr_name(true)), function() {
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

        toggle : function (target) {
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

        resize : function () {
            var dropdown = this.S('[' + this.attr_name() + '-content].open'),
                target = this.S("[" + this.attr_name() + "='" + dropdown.attr('id') + "']");

            if (dropdown.length && target.length) {
                this.css(dropdown, target);
            }
        },

        css : function (dropdown, target) {
            var left_offset = Math.max((target.width() - dropdown.width()) / 2, 8),
                settings = target.data(this.attr_name(true) + '-init') || this.settings;

            this.clear_idx();

            if (this.small()) {
                var p = this.dirs.bottom.call(dropdown, target, settings);

                dropdown.attr('style', '').removeClass('drop-left drop-right drop-top').css({
                    position : 'absolute',
                    width: '95%',
                    'max-width': 'none',
                    top: p.top
                });

                dropdown.css(Foundation.rtl ? 'right':'left', left_offset);
            } else {

                this.style(dropdown, target, settings);
            }

            return dropdown;
        },

        style : function (dropdown, target, settings) {
            var css = $.extend({position: 'absolute'},
                this.dirs[settings.align].call(dropdown, target, settings));

            dropdown.attr('style', '').css(css);
        },

        // return CSS property object
        // `this` is the dropdown
        dirs : {
            // Calculate target offset
            _base : function (t) {
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
                    self.adjust_pip(this,t,s,p);
                }

                if (Foundation.rtl) {
                    return {left: p.left - this.outerWidth() + t.outerWidth(),
                        top: p.top - this.outerHeight()};
                }

                return {left: p.left, top: p.top - this.outerHeight()};
            },
            bottom: function (t,s) {

                var self = Foundation.libs.dropdown,
                    p = self.dirs._base.call(this, t);

                if (p.missRight == true) {
                    p.left = p.left - this.outerWidth() + t.outerWidth();
                }

                if (t.outerWidth() < this.outerWidth() || self.small() || this.hasClass(s.mega_menu)) {
                    self.adjust_pip(this,t,s,p);
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
                    p.left =  p.left + this.outerWidth();
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
                    self.adjust_pip(this,t,s,p);
                }

                return {left: p.left + t.outerWidth(), top: p.top};
            }
        },

        // Insert rule to style psuedo elements
        adjust_pip : function (dropdown,target,settings,position) {
            var sheet = Foundation.stylesheet,
                pip_offset_base = 8;

            if (dropdown.hasClass(settings.mega_class)) {
                pip_offset_base = position.left + (target.outerWidth()/2) - 8;
            }
            else if (this.small()) {
                pip_offset_base += position.left - 8;
            }

            this.rule_idx = sheet.cssRules.length;

            //default
            var sel_before = '.f-dropdown.open:before',
                sel_after  = '.f-dropdown.open:after',
                css_before = 'left: ' + pip_offset_base + 'px;',
                css_after  = 'left: ' + (pip_offset_base - 1) + 'px;';

            if (position.missRight == true) {
                pip_offset_base = dropdown.outerWidth() - 23;
                sel_before = '.f-dropdown.open:before',
                    sel_after  = '.f-dropdown.open:after',
                    css_before = 'left: ' + pip_offset_base + 'px;',
                    css_after  = 'left: ' + (pip_offset_base - 1) + 'px;';
            }

            //just a case where right is fired, but its not missing right
            if (position.triggeredRight == true) {
                sel_before = '.f-dropdown.open:before',
                    sel_after  = '.f-dropdown.open:after',
                    css_before = 'left:-12px;',
                    css_after  = 'left:-14px;';
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
        clear_idx : function () {
            var sheet = Foundation.stylesheet;

            if (typeof this.rule_idx !== 'undefined') {
                sheet.deleteRule(this.rule_idx);
                sheet.deleteRule(this.rule_idx);
                delete this.rule_idx;
            }
        },

        small : function () {
            return matchMedia(Foundation.media_queries.small).matches &&
                !matchMedia(Foundation.media_queries.medium).matches;
        },

        off: function () {
            this.S(this.scope).off('.fndtn.dropdown');
            this.S('html, body').off('.fndtn.dropdown');
            this.S(window).off('.fndtn.dropdown');
            this.S('[data-dropdown-content]').off('.fndtn.dropdown');
        },

        reflow : function () {}
    };
}(jQuery, window, window.document));

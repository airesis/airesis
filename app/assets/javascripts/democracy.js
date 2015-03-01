!window.console && (console = {
    log: function () {
    }
});

var $viewport;

function switchText(button) {
    var other_ = button.data('other');
    var text_ = button.text();
    button.data('other', text_);
    button.text(other_);
}


function scrollToElement(element) {
    $viewport.animate({
        scrollTop: element.offset().top - 160
    }, 2000);

    // Stop the animation if the user scrolls. Defaults on .stop() should be fine
    $viewport.bind("scroll mousedown DOMMouseScroll mousewheel keyup", function (e) {
        if (e.which > 0 || e.type === "mousedown" || e.type === "mousewheel") {
            $viewport.stop().unbind('scroll mousedown DOMMouseScroll mousewheel keyup'); // This identifies the scroll as a user action, stops the animation, then unbinds the event straight after (optional)
        }
    });
    return false;
}

//var cards_delay = 0;

//function show_cards() {
//    cards_delay = 0;
//    $('.card.appear').appear({force_process: true});
//}

function mybox_animate() {
    $(".mybox .mybox_button").click(function () {
        if ($(this).data('menu2show') == 0) {
            $(this).data('menu2show', 1);
            $(this).parent().find('.mycont').slideDown();
            $(this).removeClass('close');

        } else {
            $(this).data('menu2show', 0);
            $(this).parent().find('.mycont').slideUp();
            $(this).addClass('close');
        }
    });
}

function sticky_relocate() {
    var window_top = $(window).scrollTop();
    $('.sticky-anchor').each(function () {
        var div_top = $(this).offset().top;
        if (window_top > (div_top - 90)) {
            $('.sticky').addClass('stick');
        } else {
            $('.sticky').removeClass('stick');
        }
    });
}


function disegnaProgressBar() {
    $('.timeline').each(function () {
        if ($(this).attr('data-initialized') == 'true') return;
        var time_ = $('.time', this);
        var good_ = $('.good', this);
        var quorum_ = $('.cur.quorum', this);
        var badquorum_ = $('.cur.bad.quorum', this);
        time_.animate({width: time_.data('percentage') + '%'}, 2000);
        good_.animate({width: good_.data('percentage') + '%'}, 2000);
        quorum_.css('left', quorum_.data('percentage') + '%');
        badquorum_.css('left', badquorum_.data('percentage') + '%');
        $(this).attr('data-initialized', 'true');
    });

    $('.timeline .cur').qtip({
        position: {
            at: 'bottom center',
            my: 'top center',
            viewport: $(window)
        },
        style: {
            classes: 'qtip-light qtip-shadow',
            tip: {
                corner: true,
                width: 5,
                height: 5
            }
        }
    });

    $('.proposal_bottom .contributes, .proposal_bottom .timeleft, .proposal_bottom .rankDescription').qtip({
        position: {
            at: 'bottom center',
            my: 'top center'
        },
        style: {
            classes: 'qtip-light qtip-shadow',
            tip: {
                corner: true,
                width: 5,
                height: 5
            }
        }
    });

    $('.alert.notify[data-load="true"]').each(function () {
        $(this).qtip({
            content: {
                text: 'Loading...', // The text to use whilst the AJAX request is loading
                ajax: {
                    url: '/alerts/proposal', // URL to the local file
                    type: 'GET', // POST or GET
                    data: 'proposal_id=' + $(this).data('proposal-id'),
                    success: function (data, status) {
                        this.set('content.text', data);
                    }
                }
            },
            position: {
                my: 'bottom center',
                at: 'top center',
                viewport: $(window),
                effect: false
            },
            style: {
                classes: 'qtip-light qtip-shadow'
            },
            hide: {
                fixed: true,
                delay: 500
            }
        });
    });


    $('.proposal_bottom .participants').each(function () {
        $(this).qtip({
            content: $('.authors', this),
            position: {
                at: 'bottom center',
                my: 'top center'
            },
            style: {
                classes: 'qtip-light qtip-shadow',
                tip: {
                    corner: true,
                    width: 5,
                    height: 5
                }
            }
        });
    });

    $(function () {
        $(".progress_bar").progressBar({
            boxImage: '<%=asset_path "progressbar.gif"%>',
            barImage: '<%=asset_path "progressbg_green.gif"%>',
            showText: true,
            textFormat: 'custom'
        });
    });
}

function hideDisableButton(button) {
    button.hide();
    var toAdd = $('<div class="waitDiv"><%=image_tag "facebook-loader.gif", :alt => "loading..."%> </div>');
    toAdd.width(button.outerWidth(true));
    toAdd.height(button.outerHeight(true));
    button.after(toAdd);
}

function showDisableButton(button) {
    button.show();
    $('.waitDiv').remove();
}

function hideDisableGButton(button) {
    //button.hide();
    var textInside = button.html();

    var toAdd = $('<div class="load"><span>LOADING</span><%=image_tag "gloading.gif", :alt => ""%></div>');
    button.width(button.width());
    button.height(button.height());
    button.empty();
    button.append($('<span class="hidden">').append(textInside));
    button.append(toAdd);
    button.attr('disabled', 'disabled');
    button.bind('click.killlink', function (e) {
        e.preventDefault();
        return false;
    });
}

function showDisableGButton(button) {
    var content = $('.hidden', button).html();
    $('.load', button).remove();
    button.html(content);
    button.removeAttr('disabled');
    button.unbind('click.killlink');
}

var et = {};


function calculate_event_times() {
    et.est = $("#event_starttime");
    et.eet = $("#event_endtime");
    et.eventStartTime = et.est.datetimepicker("getDate");
    et.eventEndTime = et.eet.datetimepicker("getDate");
    et.eventStartDate = new Date(et.eventStartTime);
    et.eventEndDate = new Date(et.eventEndTime);

    et.get = $("#groups_end_time");
    et.cet = $("#candidates_end_time");
    et.groupTime = et.get.datetimepicker("getDate");
    et.candidatesTime = et.cet.datetimepicker("getDate");
    et.groupDate = new Date(et.groupTime);
    et.candidatesDate = new Date(et.candidatesTime);
    //console.log('endate: ' + et.eventEndDate);
    //console.log('startdate: ' + et.eventStartDate);
    //console.log('candidatedate: ' + et.candidatesDate);
    //console.log('entime: ' + et.eventEndTime / 1000);
    //console.log('startime: ' + et.eventStartTime / 1000);
    //console.log('candidatetime: ' + et.candidatesTime / 1000);
}

function addMinutes(date, minutes) {
    return new Date(date.getTime() + minutes * 60000);
}

function upperMinutes(date, step) {
    return addMinutes(date, step - (date.getMinutes() % step));
}

function dateToString(date) {
    var day_ = date.getDate()
    var month_ = date.getMonth() + 1
    var year_ = date.getFullYear()

    var hours_ = date.getHours()
    var minutes_ = date.getMinutes()

    if (minutes_ < 10)
        minutes_ = "0" + minutes_


    return day_ + '/' + month_ + '/' + year_ + ' ' + hours_ + ':' + minutes_;
}

function startTimeChanged() {

    //se la data inizio supera la data fine
    if (!(et.eventEndDate.getTime() > et.eventStartDate.getTime())) {
        //reimposto la data fine avanti
        var min15 = addMinutes(et.eventStartTime, 15);
        et.eet.datetimepicker("setDate", min15);
    }

    //se la data inizio supera la data fine gruppi
    if (!(et.groupDate.getTime() > et.eventStartDate.getTime())) {
        //reimposto la data gruppi avanti
        et.get.datetimepicker("setDate", et.eventStartTime);
    }

    //se la data inizio supera la data fine candidati
    if (!(et.candidatesDate.getTime() > et.eventStartDate.getTime())) {
        //reimposto la data candidati avanti
        et.cet.datetimepicker("setDate", et.eventStartTime);
    }

    //imposta come data minima quella di inizio dell'evento
    var diff = Math.floor(( et.eventStartDate - new Date()) / 86400000);
    //et.eet.datetimepicker("option","minDate",diff);
}

function endTimeChanged() {
    //se la data inizio supera la data fine
    if (!(et.eventEndDate.getTime() > et.eventStartDate.getTime())) {
        //reimposta la data inizio indietro
        var min15 = addMinutes(et.eventStartTime, -15)
        et.est.datetimepicker("setDate", min15);
    }
}

function groupsTimeChanged() {

    //se supera la data fine candidati
    if (!(et.candidatesDate.getTime() > et.groupDate.getTime())) {
        //sposto la data fine candidati
        $("#candidates_end_time").datetimepicker("setDate", et.groupTime);
    }

    //se supera la data fine evento
    if (!(et.eventEndDate.getTime() > et.groupDate.getTime())) {
        // sposto la data fine evento in avanti
        et.eet.datetimepicker("setDate", et.groupTime);
    }

    //imposta un limite inferiore alla data fine dei candidati
    var diff = Math.floor(( et.groupDate - new Date()) / 86400000);
    $("#candidates_end_time").datetimepicker("option", "minDate", diff);
}

function candidatesTimeChanged() {
    //se è inferiore alla data fine gruppi
    if (!(et.candidatesDate.getTime() > et.groupDate.getTime())) {
        //sposto indietro la data fine gruppi
        $("#groups_end_time").datetimepicker("setDate", et.candidatesTime);
    }

    //se supera la data fine evento
    if (!(et.eventEndDate.getTime() > et.candidatesDate.getTime())) {
        // sposto la data fine evento in avanti
        var min15 = addMinutes(et.candidatesTime, 15);
        et.eet.datetimepicker("setDate", min15);
    }
}

var datePickerOptions = {
    changeMonth: false,
    changeYear: false,
    yearRange: "c:c+10",
    minDate: -2,
    maxDate: "+10Y",
    duration: "",
    showTime: true,
    constrainInput: true,
    stepMinute: 5,
    stepHour: 1,
    altTimeField: "alt"
};


function start_end_fdatetimepicker(start, end, min_minutes, suggested_minutes) {
    min_minutes = typeof min_minutes !== 'undefined' ? min_minutes : 5;
    suggested_minutes = typeof suggested_minutes !== 'undefined' ? suggested_minutes : min_minutes;

    start.fdatetimepicker()
        .on('hide', function (event) {
            var settings = window.ClientSideValidations.forms[event.currentTarget.form.id];
            $(event.currentTarget).isValid(settings.validators);
            var eventStartTime_ = $(event.currentTarget).fdatetimepicker('getDate');
            var minStartTime = addMinutes(eventStartTime_, min_minutes);
            var eventEndTime_ = end.fdatetimepicker("getDate");
            end.fdatetimepicker("setStartDate", minStartTime);
            if (eventEndTime_ < minStartTime) {
                end.fdatetimepicker("setDate", addMinutes(eventStartTime_, suggested_minutes));
                showOnField(end, 'Changed!');
            }

        });


    var minTime_ = start.fdatetimepicker('getDate');
    end.fdatetimepicker({startDate: minTime_})
        .on('hide', function (event) {
            var settings = window.ClientSideValidations.forms[event.currentTarget.form.id];
            $(event.currentTarget).isValid(settings.validators);
        });
}


function select2town(element) {
    element.select2({
        cacheDataSource: [],
        placeholder: Airesis.i18n.type_for_town,
        query: function (query) {
            self = this;
            var key = query.term;
            var cachedData = self.cacheDataSource[key];

            if (cachedData) {
                query.callback({results: cachedData});
                return;
            } else {
                $.ajax({
                    url: '/comunes',
                    data: {q: query.term},
                    dataType: 'json',
                    type: 'GET',
                    success: function (data) {
                        self.cacheDataSource[key] = data;
                        query.callback({results: data});
                    }
                })
            }
        },
        escapeMarkup: function (m) {
            return m;
        }
    });
}

function disegnaCountdown() {
    $('div[data-countdown]').each(function () {
        $(this).countdown($.extend({
            since: new Date($(this).data('time')),
            significant: 1,
            format: 'ms',
            layout: Airesis.i18n.countdown
        }, $.countdown.regionalOptions[Airesis.i18n.locale]));
    })
}


function getURLParameter(name) {
    return decodeURIComponent(
        (location.search.match(RegExp("[?|&]" + name + '=(.+?)(&|$)')) || [, null])[1]
    );
}


function array2dToJson(a, p, nl) {
    var i, j, s = '{"' + p + '":[';
    nl = nl || '';
    for (i = 0; i < a.length; ++i) {
        s += nl + array1dToJson(a[i]);
        if (i < a.length - 1) {
            s += ',';
        }
    }
    s += nl + ']}';
    return s;
}

function array1dToJson(a, p) {
    var i, s = '[';
    for (i = 0; i < a.length; ++i) {
        if (typeof a[i] == 'string') {
            s += '"' + a[i] + '"';
        }
        else { // assume number type
            s += a[i];
        }
        if (i < a.length - 1) {
            s += ',';
        }
    }
    s += ']';
    if (p) {
        return '{"' + p + '":' + s + '}';
    }
    return s;
}

function stripScripts(s) {
    var div = document.createElement('div');
    div.innerHTML = s;
    var scripts = div.getElementsByTagName('script');
    var i = scripts.length;
    while (i--) {
        scripts[i].parentNode.removeChild(scripts[i]);
    }
    return div.innerHTML;
}


var last_poll_start = new Date().getTime() / 1000;
var last_poll_end = new Date().getTime() / 1000;

function poll_if_not_recent() {
    var now_ = new Date().getTime() / 1000;
    if (last_poll_end > last_poll_start && last_poll_end < (now_ - 5)) {
        poll();
    }
}

var document_title = document.title;

function set_alerts_number(number) {
    $('.alert.notify.boxed').append(number);
    document.title = '(' + number + ') ' + document_title;
}

function reset_alerts_number() {
    var box_ = $('.alert.notify.boxed');
    box_.remove();
    document.title = document_title;
}

function decrease_box_number(box_) {
    var num_ = parseInt(box_.html());
    if (num_ > 1) {
        num_ -= 1;
        box_.html(num_);
    }
    else {
        box_.remove();
    }
}

function decrease_alerts_number() {
    var box_ = $('.alert.notify.boxed');
    var num_ = parseInt(box_.html());
    if (num_ > 1) {
        num_ -= 1;
        box_.html(num_);
        document.title = '(' + num_ + ') ' + document_title;
    }
    else {
        reset_alerts_number();
    }
}


function read_notifica(el) {
    var parent_ = $(el).parent();
    parent_.addClass('old').removeClass('new');
    var url_ = parent_.attr('href');
    var type_id = $(el).data('type_id');
    decrease_alerts_number();

    var proposal_id = parent_.data('proposal-id');
    if (proposal_id) {
        $('.alert.notify[data-proposal-id=' + proposal_id + ']').each(function () {
            decrease_box_number($(this));
        });
    }

    $.ajax({
        dataType: 'js',
        type: 'get',
        url: url_
    });
}

function sign_all_as_read(id) {
    $.ajax({
        data: 'id=' + id,
        url: '/alerts/check_all/',
        type: 'post',
        dataType: 'js',
        complete: function (data) {
            reset_alerts_number();
            $('.card.mess').each(function () {
                $(this).addClass('old');
                var proposal_id = $(this).data('proposal-id');
                if (proposal_id) {
                    $('.alert.notify[data-proposal-id=' + proposal_id + ']').each(function () {
                        decrease_box_number($(this));
                    });
                }
            });
        }
    });
}

function poll() {
    last_poll_start = new Date().getTime() / 1000;
    $.ajax({
        dataType: 'JSON',
        type: 'GET',
        url: "/alerts",
        success: function (data) {
            if (data.count > 0) {
                $('#alerts_link').append($('<button class="alert notify boxed">').append(data.count));
                document.title = '(' + data.count + ') ' + document.title;
            }
            var n_container = $("#alert_cont");
            n_container.empty();
            var read_container = $('<div class="read_all">');
            read_container.append($('<a href="#" onclick="sign_all_as_read(' + data.id + ');return false;">' + Airesis.i18n.alerts_sign_has_read + '</a>'));
            read_container.append(' · ')
            read_container.append($('<a href="/users/alarm_preferences">' + Airesis.i18n.alarm_settings + '</a>'));
            var sub_container = $('<div class="cont1">');
            n_container.append(read_container).append(sub_container);
            for (var j = 0; j < data.alerts.length; j++) {
                var alert = data.alerts[j];
                var li_alert_con = $('<li></li>');

                var alert_container = $('<a class="card mess" href="' + alert.path + '">');
                li_alert_con.append(alert_container);
                alert_container.addClass(alert.checked ? 'old' : 'new');

                if (alert.proposal_id) {
                    alert_container.attr('data-proposal-id', alert.proposal_id);
                }

                var row_container = $('<div class="row"></div>');
                var column_image = $('<div class="columns small-2"></div>');
                var column_message = $('<div class="columns small-10"></div>');
                row_container.append(column_image).append(column_message)
                column_message.append($('<p class="p2">' + alert.text + '</p>'));
                column_message.append($('<div class="p1">' + alert.created_at + '</div>'));
                column_image.append($('<img src="' + alert.image + '"/>'));
                alert_container.append(row_container);
                alert_container.append('<div class="clearboth"></div>');
                if (!alert.checked) {
                    alert_container.append($('<i class="fa fa-circle-o read" title="' + Airesis.i18n.alert_read + '" data-type_id="' + data.id + '" onclick="read_notifica(this);return false;"></i>'));
                }
                sub_container.append(li_alert_con);
            }
            if (data.alerts.length == 0) {
                sub_container.append($('<span>' + Airesis.i18n.no_alerts + '</span>'));
            }

            $('.cont1')
                .bind('mousewheel DOMMouseScroll', function (e) {
                    Airesis.scrollLock(this,e);
                });
            disegnaCountdown();

        },
        error: function (data) {
            console.error(data);
        },
        complete: function (data) {
            //setTimeout(poll, 60000);
            last_poll_end = new Date().getTime() / 1000;
        }
    });
}


function set_noise_data() {
    $('#comments_active').val($('#active .noise_element').map(function () {
        return $(this).data('id')
    }).get());
    $('#comments_inactive').val($('#inactive .noise_element').map(function () {
        return $(this).data('id')
    }).get());
}

function secondsToString(seconds) {
    var years = Math.floor(seconds / 31536000);
    var max = 5;
    var current = 0;
    var str = "";
    if (years && current < max) {
        str += years + ' anni ';
        current++;
    }
    var days = Math.floor((seconds %= 31536000) / 86400);
    if (days && current < max) {
        str += days + ' giorni ';
        current++;
    }
    var hours = Math.floor((seconds %= 86400) / 3600);
    if (hours && current < max) {
        str += hours + ' ore ';
        current++;
    }
    var minutes = Math.floor((seconds %= 3600) / 60);
    if (minutes && current < max) {
        str += minutes + ' minuti ';
        current++;
    }
    var seconds = seconds % 60;
    if (seconds && current < max) {
        str += seconds + ' secondi ';
        current++;
    }

    return str;
}

function getQueryParam(param) {
    var result = window.location.search.match(
        new RegExp("(\\?|&)" + param + "(\\[\\])?=([^&]*)")
    );

    return result ? result[3] : false;
}

function addQueryParam(url, key, val) {
    var parts = url.match(/([^?#]+)(\?[^#]*)?(\#.*)?/);
    var url = parts[1];
    var qs = parts[2] || '';
    var hash = parts[3] || '';

    if (!qs) {
        return url + '?' + key + '=' + encodeURIComponent(val) + hash;
    } else {
        var qs_parts = qs.substr(1).split("&");
        var i;
        for (i = 0; i < qs_parts.length; i++) {
            var qs_pair = qs_parts[i].split("=");
            if (qs_pair[0] == key) {
                qs_parts[i] = key + '=' + encodeURIComponent(val);
                break;
            }
        }
        if (i == qs_parts.length) {
            qs_parts.push(key + '=' + encodeURIComponent(val));
        }
        return url + '?' + qs_parts.join('&') + hash;
    }
}

//hide left panel if the window width is not large enough
function hideLeftPanel() {
    $('#menu-left').addClass('contributes_shown')
    $('#centerpanelextended').addClass('contributes_shown')

}

//hide left panel if the window width is not large enough
function showLeftPanel() {
    $('#menu-left').removeClass('contributes_shown')
    $('#centerpanelextended').removeClass('contributes_shown')
}

function fitRightMenu(fetched) {
    fetched.addClass('contributes_shown');
    fetched.css('display', '');

    if (matchMedia(Foundation.media_queries['medium']).matches) {
        console.log('set height');
        fetched.height($(window).height() - 110);
    }

    $(window).resize(function () {
        if (matchMedia(Foundation.media_queries['medium']).matches) {
            console.log('set height');
            fetched.height($(window).height() - 110);
        }
    });
}

//custom formatter for categories in select2 dropdown
function formatCategory(state) {
    if (!state.id) return state.text; // optgroup
    var imgsrc = $(state.element).data('imagesrc');
    return "<img src=\"" + imgsrc + "\"/> " + state.text;
}

//custom formatter for quora in select2 dropdown
function formatQuorum(state) {
    var element_ = state.element;
    if (!state.id) return state.text; // optgroup
    return "<div> <div class=\"quorum_title\">" + state.text + "</div> <div class=\"quorum_desc\">" + $(element_).data('description') + "</div></div>";
}

//custom formatter for vote period in select2 dropdown
function formatPeriod(state) {
    var element_ = state.element;
    if (!state.id) return state.text; // optgroup
    return "<div> <div class=\"period_title\">" + state.text + "</div> <div class=\"period_desc\">" + $(element_).data('title') + "</div></div>";
}


function initTextAreaTag() {
    $('.reply_textarea[data-initialized!=1]').each(function () {
        $(this).textntags({
            triggers: {'@': {uniqueTags: false}},
            onDataRequest: function (mode, query, triggerChar, callback) {
                var data = ProposalsShow.nicknames;

                query = query.toLowerCase();
                var found = _.filter(data, function (item) {
                    return item.name.toLowerCase().indexOf(query) > -1;
                });

                callback.call(this, found);
            }
        });
        $(this).attr('data-initialized', 1);
    });
}

function airesis_close_reveal() {
    "use strict";
    $('.reveal-modal:visible').foundation('reveal', 'close');
}

function airesis_reveal(element_, remove_on_close) {
    remove_on_close = typeof remove_on_close !== 'undefined' ? remove_on_close : true;
    element_.foundation().foundation('reveal', 'open');
    if (remove_on_close) {
        $(document).on('closed', element_, function () {
            element_.remove();
        });
    }
    airesis_reveal_refresh(element_);
}

//to call when reveal content is replaced by a new one
function airesis_reveal_refresh(element_) {
    element_.append('<a class="close-reveal-modal">&#215;</a>');
    element_.find('[data-reveal-close]').click(function () {
        element_.foundation().foundation('reveal', 'close');
    });
}

/**
 * posiziona il marcatore sull'indirizzo specificato nel campo 'Comune'
 */
function search_stuff() {
    delay(function () {
        var query = $('#search_q').val();
        if (query != null && query != "") {
            $.ajax({
                url: '/searches',
                data: 'search[q]=' + query,
                method: 'POST'
            });
        }
    }, 600);
}


jQuery.uaMatch = function (ua) {
    ua = ua.toLowerCase();

    var match = /(chrome)[ \/]([\w.]+)/.exec(ua) ||
        /(webkit)[ \/]([\w.]+)/.exec(ua) ||
        /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua) ||
        /(msie) ([\w.]+)/.exec(ua) ||
        ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua) ||
        [];

    return {
        browser: match[1] || "",
        version: match[2] || "0"
    };
};

// Don't clobber any existing jQuery.browser in case it's different
if (!jQuery.browser) {
    matched = jQuery.uaMatch(navigator.userAgent);
    browser = {};

    if (matched.browser) {
        browser[matched.browser] = true;
        browser.version = matched.version;
    }

    // Chrome is Webkit, but Webkit is also Safari.
    if (browser.chrome) {
        browser.webkit = true;
    } else if (browser.webkit) {
        browser.safari = true;
    }

    jQuery.browser = browser;
}


/*we'll do that in 4.0 TODO */

var rails = $.rails;
rails.handleRemote = function (element) {
    var method, url, data,
        crossDomain = element.data('cross-domain') || null,
        dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType),
        options;

    if (rails.fire(element, 'ajax:before')) {

        if (element.is('form')) {
            method = element.attr('method');
            url = element.attr('action');
            data = element.serializeArray();
            // memoized value from clicked submit button
            var button = element.data('ujs:submit-button');
            if (button) {
                data.push(button);
                element.data('ujs:submit-button', null);
            }
        } else if (element.is(rails.inputChangeSelector)) {
            method = element.data('method');
            url = element.data('url');
            data = element.serialize();
            if (element.data('params')) data = data + "&" + element.data('params');
        } else {
            method = element.data('method');
            url = element.attr('href');
            data = element.data('params') || null;
            if (!method) {
                if ($(window).width() <= 768) return true;
            }
        }

        options = {
            type: method || 'GET', data: data, dataType: dataType, crossDomain: crossDomain,
            // stopping the "ajax:beforeSend" event will cancel the ajax request
            beforeSend: function (xhr, settings) {
                if (settings.dataType === undefined) {
                    xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
                }
                return rails.fire(element, 'ajax:beforeSend', [xhr, settings]);
            },
            success: function (data, status, xhr) {
                element.trigger('ajax:success', [data, status, xhr]);
            },
            complete: function (xhr, status) {
                element.trigger('ajax:complete', [xhr, status]);
            },
            error: function (xhr, status, error) {
                element.trigger('ajax:error', [xhr, status, error]);
            }
        };
        // Only pass url to `ajax` options if not blank
        if (url) {
            options.url = url;
        }
        return rails.ajax(options);
    } else {
        return false;
    }
};


function showOnField(field, text) {
    var to_attach = $('<small class="warning">' + text + '</small>');
    field.parent().after(to_attach);    //attach after parent label
    field.addClass('warning');
    setTimeout(function () {
        field.removeClass('warning');
        to_attach.slideUp();
    }, 10000)
}

function showVoteResults() {
    "use strict";
    $('#votes_table').dataTable({
        "oLanguage": {
            "sLengthMenu": "Mostra _MENU_ utenti per pagina",
            "sSearch": "Cerca:",
            "sZeroRecords": "Nessun utente, spiacente..",
            "sInfo": "Sto mostrando da _START_ a _END_ di _TOTAL_ utenti",
            "sInfoEmpty": "Sto mostrando 0 utenti",
            "sInfoFiltered": "(filtrati da un totale di _MAX_ utenti)",
            "oPaginate": {
                "sPrevious": "Pagina precedente",
                "sNext": "Pagina successiva"
            }
        }
        //"aoColumns": [null,{ "bSortable": false }]
    });

    $('#votes_table_wrapper label').css("font-weight", "normal").css("font-size", "12px");

    $('#cast_table').dataTable({
        "oLanguage": {
            "sLengthMenu": "Mostra _MENU_ voti per pagina",
            "sSearch": "Cerca:",
            "sZeroRecords": "Nessun voto, spiacente..",
            "sInfo": "Sto mostrando da _START_ a _END_ di _TOTAL_ voti",
            "sInfoEmpty": "Sto mostrando 0 voti",
            "sInfoFiltered": "(filtrati da un totale di _MAX_ voti)",
            "oPaginate": {
                "sPrevious": "Pagina precedente",
                "sNext": "Pagina successiva"
            }
        },
        "bFilter": false
        //"aoColumns": [null,{ "bSortable": false }]
    });

    $('#cast_table_wrapper label').css("font-weight", "normal").css("font-size", "12px");
}

function close_all_dropdown() {
    $('.f-dropdown').foundation('dropdown', 'close', $('.f-dropdown'));
}

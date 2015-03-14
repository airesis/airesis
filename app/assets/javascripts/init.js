$(function () {

    //remove attributes for introjs from aside hidden menu. so they can work correctly
    $('aside [data-ijs]').removeAttr('data-ijs');

    ClientSideValidations.selectors.validate_inputs += ', .select2-container:visible ~ :input:enabled[data-validate]';


    $.fn.qtip.defaults = $.extend(true, {}, $.fn.qtip.defaults, {
        style: {
            classes: 'qtip-light qtip-shadow'
        }
    });

    $viewport = $('html, body');

    disegnaProgressBar();

    if ($('.sticky-anchor').length > 0) {
        $(window).scroll(sticky_relocate);
        sticky_relocate();
    }


    $('#menu-group .menu-activator').click(function () {
        var menu_ = $('#menu-left');
        if (menu_.attr('data-expshow') == 'true') {
            menu_.removeClass('small-show');
            menu_.attr('data-expshow', false);
        }
        else {
            menu_.addClass('small-show');
            menu_.attr('data-expshow', true);
        }
    });


    mybox_animate();

    var searchcache = {};
    var search_f = $('#search_q');
    if (search_f.length > 0) {
        search_f.autocomplete({
            minLength: 1,
            source: function (request, response) {
                var term = request.term;
                if (term in searchcache) {
                    response(searchcache[term]);
                    return;
                }
                $.getJSON("/searches", request, function (data, status, xhr) {
                    searchcache[term] = data;
                    response(data);
                });

            },
            focus: function (event, ui) {
                event.preventDefault();
            },
            select: function (event, ui) {
                window.location.href = ui.item.url;
                event.preventDefault();
            }

        });
        search_f.data("uiAutocomplete")._renderMenu = function (ul, items) {
            var that = this;
            $.each(items, function (index, item) {
                if (item.type == 'Divider') {
                    ul.append($("<li class='ui-autocomplete-category'>" + item.value + "</li>"));
                }
                else {
                    that._renderItemData(ul, item);
                }
            });
            $(ul).addClass('f-dropdown').addClass('medium').css('z-index', 1005).css('width', '400px');
        };
        search_f.data("uiAutocomplete")._renderItem = function (ul, item) {
            var el = $("<li>");
            var link_ = $("<a></a>");
            var container_ = $('<div class="search_result_container"></div>')
            var image_ = $('<div class="search_result_image"></div>')
            container_.append(image_);
            var desc_ = $('<div class="search_result_description"></div>');
            desc_.append('<div class="search_result_title">' + item.label + '</div>');
            var text_ = $('<div class="search_result_text">' + '</div>');
            if (item.type == 'Blog') {
                image_.append(item.image);
                text_.append('<a href="' + item.user_url + '">' + item.username + '</a>');
            }
            else if (item.type == 'Group') {
                text_.append('<div class="groupDescription"><img src="/assets/group_participants.png"><span class="count">' + item.participants_num + '</span></div>');
                text_.append('<div class="groupDescription"><img src="/assets/group_proposals.png"><span class="count">' + item.proposals_num + '</span></div>');
                image_.append('<img src="' + item.image + '"/>');
            }
            else {
                image_.append('<img src="' + item.image + '"/>');
            }
            desc_.append(text_);
            container_.append(desc_);
            container_.append('<div class="clearboth"></div>');
            link_.attr('href', item.url);
            link_.append(container_);
            el.append(link_);
            el.appendTo(ul);
            return el;
        };
    }


    $('.submenu a div').qtip({
        position: {
            at: 'bottom center',
            my: 'top center',
            effect: false
        }
    });

    $('.cur.love').qtip({
        position: {
            at: 'bottom center',
            my: 'top center',
            viewport: $(window),
            effect: false,
            adjust: {
                method: 'shift',
                x: 0, y: 0
            }
        },
        style: {
            classes: 'qtip-light qtip-shadow qtip-cur'
        },
        show: {
            solo: true
        }
    });

    $('[data-qtip]').qtip({
        style: {
            classes: 'qtip-light qtip-shadow'
        }
    });


    $(document).on('click', '[data-reveal-close]', function () {
        $('.reveal-modal:visible').foundation('reveal', 'close');
    });

    $(document).on('click', '[data-close-section-id]', function () {
        close_right_contributes($('.contribute-button[data-section_id=' + $(this).data('close-section-id') + ']'));
        return false;
    });

    $(document).on('click', '[data-close-edit-right-section]', function () {
        hideContributes();
        return false;
    });

    $(document).on('click', '[data-login]', function () {
        "use strict";
        $('#login-panel').foundation('reveal', 'open');
        return false;
    });


    $('.create_proposal').on('click', function () {
        var link = $(this);
        var create_proposal_ = $('<div class="dynamic_container reveal-modal large" data-reveal></div>');
        create_proposal_.append($(this).next('.choose_model').clone().show());

        $('.proposal_model_option', create_proposal_).click(function () {
            var create_proposal_inner_ = $('.choose_model', create_proposal_);
            var type_id = $(this).data('id');
            create_proposal_inner_.hide(1000, function () {
                create_proposal_inner_.remove();
                create_proposal_.append($('#loading-fragment').clone());
                $.ajax({
                    url: link.attr('href'),
                    data: 'proposal_type_id=' + type_id,
                    dataType: 'script'
                })
            });
        });

        airesis_reveal(create_proposal_);

        return false;
    });


    $.fn.tagcloud.defaults = {
        size: {start: 12, end: 24, unit: 'pt'},
        color: {start: '#fff', end: '#fff'}
    };

    $('[data-tag-cloud] a').tagcloud();


    function checkCharacters(field) {
        console.log('check',field);
        console.log('check',field.val());
        var button = $(this).nextAll('.search-by-text');
        if (field.val().length > 1) {
            button.removeAttr('disabled');
            console.log('search ok');
            return true
        }
        else {
            button.attr('disabled', 'disabled');
            return false
        }
    }

    //proposals index, search by text field
    $('.search-by-text').on('click', function () {
        console.log('check and go');
        var field = $(this).prevAll('.field-by-text');
        var condition = $(this).prevAll('.condition-for-text:checked');
        if (checkCharacters(field)) {
            var loc_ = addQueryParam(location.href, 'search', field.val());
            if (condition.length > 0) {
                loc_ = addQueryParam(loc_, 'or', condition.val());
            }
            else {
                loc_ = addQueryParam(loc_, 'or', '');
            }
            console.log(loc_);
            window.location = loc_;
        }
        return false;
    });

});

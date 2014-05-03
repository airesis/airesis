$(function () {
    ClientSideValidations.selectors.validate_inputs += ', .select2-container:visible ~ :input:enabled[data-validate]';


    $.fn.qtip.defaults = $.extend(true, {}, $.fn.qtip.defaults, {
        style: {
            classes: 'qtip-light qtip-shadow'
        }});

    $viewport = $('html, body');


    disegnaBottoni();

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


//    $(document.body).on('appear', '.card.appear', function (e, $affected) {
 //       cards_delay = 0;
  //      $(this).addClass('appeared');
        /*$affected.each(function() {
         var $this_ = $(this);
         setTimeout(function() {$this_.addClass("appeared")},cards_delay);
         cards_delay += 300;
         });*/
 //       cards_delay = 0;
//    });

//    $('.card.appear').appear({force_process: true});


    var searchcache = {};
    var search_f = $('#search_q');
    if (search_f.length > 0) {
        search_f.autocomplete({
            minLength: 1,
            source: function (request, response) {
                var term = request.term;
                if (term in searchcache) {
                    response(searchcache[ term ]);
                    return;
                }
                $.getJSON("/searches", request, function (data, status, xhr) {
                    searchcache[ term ] = data;
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
                text_.append('<div class="groupDescription"><img src="/assets/group_partecipants.png"><span class="count">' + item.partecipants_num + '</span></div>');
                text_.append('<div class="groupDescription"><img src="/assets/group_proposals.png"><span class="count">' + item.proposals_num + '</span></div>');
                image_.append('<img src="' + item.image + '"/>');
            }
            else {
                image_.append('<img src="' + item.image + '"/>');
            }
            desc_.append(text_);
            container_.append(desc_);
            container_.append('<div class="clearboth"></div>')
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

});
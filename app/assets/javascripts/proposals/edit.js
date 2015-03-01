var integrated_contributes = [];

function integrate_contribute(el, id) {
    var comment_ = $('#comment' + id);
    var inside_ = comment_.find('.proposal_comment');
    if ($(el).is(':checked')) {
        integrated_contributes.push(id);
        comment_.fadeTo(400, 0.3);
        inside_.attr('data-height', inside_.outerHeight());
        inside_.css('overflow', 'hidden');
        inside_.animate({height: '52px'}, 400);
        comment_.find('[id^=reply]').each(function () {
            $(this).attr('data-height', $(this).outerHeight());
            $(this).css('overflow', 'hidden');
            $(this).animate({height: '0px'}, 400);
        })
    }
    else {
        integrated_contributes.splice(integrated_contributes.indexOf(id), 1);
        comment_.fadeTo(400, 1);
        inside_.animate({height: inside_.attr('data-height')}, 400, 'swing', function () {
            inside_.css('overflow', 'auto', function () {
            });
        });
        comment_.find('[id^=reply]').each(function () {
            $(this).animate({height: $(this).attr('data-height')}, 400, 'swing', function () {
                $(this).css('overflow', 'auto', function () {

                });
            });
        })

    }
    $('#proposal_integrated_contributes_ids_list').val(integrated_contributes);
}

function geocode_panel() {

}

function updateProposal() {
    if ($('.update2').attr('disabled') != 'disabled') {
        $("form input:submit[data-type='save']").click();
    }
    return false;
}

function updateAndContinueProposal() {
    if ($('.update3').attr('disabled') != 'disabled') {
        $("form input:submit[data-type='continue']").click();
    }
    return false;
}

function scrollToSection(el) {
    scrollToElement($(".section_container[data-section_id=" + $(el).parent().parent().attr('data-section_id') + "]"));
    return false;
}

function hideContributes() {
    var right_ = $('.suggestion_right');
    if (right_.hasClass('contributes_shown')) {
        right_.removeClass('contributes_shown');
        right_.hide();
        $('#centerpanelextended').removeClass('contributes_shown');
        $('#menu-left').removeClass('contributes_shown');
    }
    else {
        right_.addClass('contributes_shown');
        right_.show();
        $('#centerpanelextended').addClass('contributes_shown');
        $('#menu-left').addClass('contributes_shown');
    }
    var contributesButton = $('.contributes');
    switchText(contributesButton);
    return false;
}

function compressSolution(element, compress) {
    var toggleMinHeight = 100,
        duration = 500,
        easing = 'swing',
        compress_ = element,
        curH = compress_.height();
    if (compress_.is(':animated')) {
        return false;
    }
    else if (compress_.attr('data-compressed') == 'false' && compress) {
        compress_.attr('data-compressed', true);
        compress_.attr('data-height', compress_.height());
        $('.sol_content', compress_).hide();
        compress_.animate(
            {
                'height': toggleMinHeight
            }, duration, easing, function () {
            });

    }
    else if (compress_.attr('data-compressed') == 'true' && !compress) {
        compress_.attr('data-compressed', false);
        compress_.animate(
            {
                'height': compress_.attr('data-height')
            }, duration, easing, function () {
            });
        $('.sol_content', compress_).show();
    }
}

function compressSolutions(compress) {
    $('.solution_main').each(function () {
        compressSolution($(this), compress);
    });
    var compressButton = $('.compress');
    return false;
}

var safe_exit = false;

function check_before_exit() {
    if (safe_exit) {
        return null;
    }
    else {
        return "Tutte le modifiche alla proposta andranno perse."
    }
}

function getCleanContent(editor_id) {
    "use strict";
    var editor = CKEDITOR.instances[editor_id];
    return editor.plugins.lite.findPlugin(editor)._tracker.getCleanContent();
}

window.onbeforeunload = check_before_exit;


$(function () {
    $(document).on('keyup', '.solution_main h3 .tit1 .tit2 input', function () {
        var id_ = $(this).closest('.solution_main').attr('data-solution_id');
        $('.navigator li[data-solution_id=' + id_ + '] span.sol_title').html($(this).val());
    });

    $(document).on('keyup', 'input.edit_label', function () {
        var id_ = $(this).closest('.section_container').attr('data-section_id');
        $('.navigator li[data-section_id=' + id_ + '] a.sec_title').text($(this).val());
    });

    $('#menu-left, #centerpanelextended').addClass('editing');

    $('#proposal_proposal_category_id').select2({
        minimumResultsForSearch: -1,
        formatResult: formatCategory,
        formatSelection: formatCategory,
        escapeMarkup: function (m) {
            return m;
        }
    });

    var suggestion_right_ = $('.suggestion_right');
    fitRightMenu(suggestion_right_);
    suggestion_right_
        .bind('mousewheel DOMMouseScroll', function (e) {
            if (matchMedia(Foundation.media_queries['medium']).matches) {
                Airesis.scrolllock(suggestion_right_,e);
            }
        });


    fetchContributes();

    function update_sequences(container) {
        var i = 0;
        container.find('.section_container').each(function (el) {
            var id = $(this).find('textarea').attr('id');
            var seq_id = id.replace(/paragraphs_attributes.*/, 'seq');
            $('#' + seq_id).val(i++);
        });
    }

    function update_solution_sequences() {
        var i = 0;
        $('.solution_main').each(function (el) {
            var id = $(this).data('solution_id');
            var seq_id = 'proposal_solutions_attributes_' + id + '_seq';
            $('#' + seq_id).val(i++);
        });
    }


    //compress and expand navigator
    $('.navigator').on('click', 'li:has(ul)', function (event) {
        if (this == event.target) {
            $(this).toggleClass('expanded');
            $(this).children('ul').toggle();
            var solution_ = $('.solution_main[data-solution_id=' + $(this).data('solution_id') + ']');
            compressSolution(solution_, !solution_.attr('data-compressed'));
        }
        return false;
    });
    $('.navigator li:has(ul)').addClass('collapsed expanded');

    $('#expandList')
        .unbind('click')
        .click(function () {
            $('.collapsed').addClass('expanded');
            $('.collapsed').children('ul').show();
            compressSolutions(false);
        });
    $('#collapseList')
        .unbind('click')
        .click(function () {
            $('.collapsed').removeClass('expanded');
            $('.collapsed').children('ul').hide();
            compressSolutions(true);
        });


    //todo code refactor to make it better
    $('.navigator')//move up a proposal paragraph
        .on('click', '.sec_nav .move_up', function () {
            var list_element = $(this).parent();
            var section_id = list_element.data('section_id');
            var to_move = $('.section_container[data-section_id=' + section_id + ']');
            var to_exchange = to_move.prevAll('.section_container').first();
            to_move.after(to_exchange);

            //navigator update
            var list_element_ex = list_element.prev();
            list_element.after(list_element_ex);

            update_sequences($(".sections_column"));
        })  //move down a proposal paragraph
        .on('click', '.sec_nav .move_down', function () {
            var list_element = $(this).parent();
            var section_id = list_element.data('section_id');
            var to_move = $('.section_container[data-section_id=' + section_id + ']');
            var to_exchange = to_move.nextAll('.section_container').first();
            to_move.before(to_exchange);

            //navigator update
            var list_element_ex = list_element.next();
            list_element.before(list_element_ex);

            update_sequences($(".sections_column"));
        })//remove a proposal paragraph
        .on('click', '.sec_nav .remove', function () {
            var list_element = $(this).parent();
            var section_id = list_element.data('section_id');
            var to_remove = $('.section_container[data-section_id=' + section_id + ']');
            to_remove.find($('.remove_button a')).click();

            update_sequences($(".sections_column"));
        })  //move up a solution paragraph
        .on('click', '.sol_sec_nav .move_up', function () {
            var list_element = $(this).parent();
            var solution_id = list_element.parent().parent().data('solution_id');
            var section_id = list_element.data('section_id');
            var to_move = $('.solutions_column[data-solution_id=' + solution_id + '] .section_container[data-section_id=' + section_id + ']');
            var to_exchange = to_move.prevAll('.section_container').first();
            to_move.after(to_exchange);

            //navigator update
            var list_element_ex = list_element.prev();
            list_element.after(list_element_ex);

            update_sequences($('.solutions_column[data-solution_id=' + solution_id + ']'));
        }) //move down a solution paragraph
        .on('click', '.sol_sec_nav .move_down', function () {
            var list_element = $(this).parent();
            var solution_id = list_element.parent().parent().data('solution_id');
            var section_id = $(this).parent().data('section_id');
            var to_move = $('.solutions_column[data-solution_id=' + solution_id + '] .section_container[data-section_id=' + section_id + ']');
            var to_exchange = to_move.nextAll('.section_container').first();
            to_move.before(to_exchange);

            //navigator update
            var list_element_ex = list_element.next();
            list_element.before(list_element_ex);

            update_sequences($('.solutions_column[data-solution_id=' + solution_id + ']'));
        })  //remove a solution paragraph
        .on('click', '.sol_sec_nav .remove', function () {
            var list_element = $(this).parent();
            var solution_id = list_element.parent().parent().data('solution_id');
            var section_id = $(this).parent().data('section_id');
            var to_remove = $('.solutions_column[data-solution_id=' + solution_id + '] .section_container[data-section_id=' + section_id + ']');
            to_remove.find($('.remove_button a')).click();

            update_sequences($('.solutions_column[data-solution_id=' + solution_id + ']'));
        }). //move up a solution
        on('click', '.sol_nav .sol.move_up', function () {
            var list_element = $(this).parent();
            var solution_id = list_element.data('solution_id');
            var to_move = $('.solution_main[data-solution_id=' + solution_id + ']');
            var to_exchange = to_move.prevAll('.solution_main').first();
            to_move.after(to_exchange);

            //navigator update
            var list_element_ex = list_element.prev();
            list_element.after(list_element_ex);
            update_solution_sequences();

            //todo update_sequences($('.solutions_column[data-solution_id='+solution_id+']'));
        }). //move down a solution
        on('click', '.sol_nav .sol.move_down', function () {
            var list_element = $(this).parent();
            var solution_id = list_element.data('solution_id');
            var to_move = $('.solution_main[data-solution_id=' + solution_id + ']');
            var to_exchange = to_move.nextAll('.solution_main').first();
            to_move.before(to_exchange);

            //navigator update
            var list_element_ex = list_element.next();
            list_element.before(list_element_ex);
            update_solution_sequences();

            //todo update_sequences($('.solutions_column[data-solution_id='+solution_id+']'));
        }). //remove a solution
        on('click', '.sol_nav .sol.remove', function () {
            var list_element = $(this).parent();
            var solution_id = list_element.data('solution_id');
            var to_remove = $('.solution_main[data-solution_id=' + solution_id + ']');
            //execute action clicking old button, now hidden
            to_remove.find($('.remove_sol_button a')).click();
            list_element.remove();
            update_solution_sequences();
            //todo update_sequences($('.solutions_column[data-solution_id='+solution_id+']'));
        });
})
;



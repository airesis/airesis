var clicked;
var contributes = [];
var checkActive = false;

function scroll_to_vote_panel() {
    scrollToElement($(".vote_panel"));
    return false;
}

function contribute(section_id) {
    $('#proposal_comment_section_id').val(section_id);
    $viewport.animate({
        scrollTop: $("#proposal_comment_content").offset().top - 150
    }, 2000, function () {
        $('#proposal_comment_content').focus();
        $('#comment-form-comment').effect('highlight', {}, 3000);
    });


    // Stop the animation if the user scrolls. Defaults on .stop() should be fine
    $viewport.bind("scroll mousedown DOMMouseScroll mousewheel keyup", function (e) {
        if (matchMedia(Foundation.media_queries['medium']).matches && e.which > 0 || e.type === "mousedown" || e.type === "mousewheel") {
            $viewport.stop().unbind('scroll mousedown DOMMouseScroll mousewheel keyup'); // This identifies the scroll as a user action, stops the animation, then unbinds the event straight after (optional)
        }
    });

    return false;
}
function cancel_edit_comment(id) {
    if (confirm('Are you sure?')) {
        $('.proposalComment[data-id='+id+'] .edit_panel').fadeOut(function() {
            $(this).remove();
            $('.proposalComment[data-id='+id+'] .baloon-content').fadeIn();
        });
    }
}

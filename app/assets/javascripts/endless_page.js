/**
 * @author coorasse
 */
var currentPage = 1;
var checkActive = true;

function resetCounter() {
    currentPage = 1;
}

function checkScroll() {
    if (nearBottomOfPage() && checkActive) {
        checkActive = false;
        currentPage++;
        console.log('end '+currentPage);
        $.ajax({
            url: '',
            data: {page: currentPage},
            type: 'get'
        });
    } else {
        setTimeout("checkScroll()", 250);
    }
}

function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
    return $(document).height() - ($(window).height() + $(window).scrollTop());
}


$(function () {
    checkScroll();
});
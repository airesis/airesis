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
        console.log('near bottom');
        currentPage++;
        $.ajax({ url: '?page=' + currentPage, type: 'get'});
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
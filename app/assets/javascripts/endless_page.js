/**
 * @author coorasse
 */
var currentPage = 1;
var checkActive = true;
var timer = 0;

function resetCounter() {
    currentPage = 1;
}

function checkScroll() {
    if (nearBottomOfPage() && checkActive) {
        checkActive = false;
        currentPage++;
        $.ajax({
            url: window.location,
            data: {page: currentPage},
            type: 'get'
        });
    } else {
        timer = setTimeout(checkScroll, 250);
    }
}

function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom() {
    return $(document).height() - ($(window).height() + $(window).scrollTop());
}

function reset() {
    //console.log('reset');
    resetCounter();
    if (timer) {
        clearTimeout(timer);
        timer = 0;
    }
    checkActive = true;
    checkScroll();
}

$(function () {
    checkScroll();
});

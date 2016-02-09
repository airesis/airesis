var currentPage = 0;

function resetCounter() {
    currentPage = 0;
}

function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
    return $(document).height() - ($(window).height() + $(window).scrollTop());
}

function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

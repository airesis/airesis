var currentPage = 0;

function resetCounter() {
    currentPage = 0;
}

function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
    return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}


function hideRankPanel2(panel) {
    $('.voteup', panel).hide();
    $('.votedown', panel).hide();
    $('.votedup', panel).hide();
    $('.voteddown', panel).hide();
    $('.loadingup', panel).show();
    $('.loadingdown', panel).show();
}

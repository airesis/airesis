/**
 * @author coorasse
 */
var currentPage = 1;

function resetCounter () {
	currentPage = 1;
}

function checkScroll() {
  if (nearBottomOfPage()) {
    currentPage++;
    url = window.location
  	cat = getURLParameter('category');
  	view = getURLParameter('view');
  	nurl = '/proposals/endless_index?scroll=true'
    if (cat != null && cat != 'null')
    	nurl += '&category='+cat
    if (view != null && view != 'null')
    	nurl += '&view='+view
		$.ajax({ url: nurl +'&page=' + currentPage, type:'get'});
  } else {
    setTimeout("checkScroll()", 250);
  }
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

$(function() {
  checkScroll();
});
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
  	console.log('url: ' + url);
  	cat = getURLParameter('category');
    console.log(cat);
    if (cat != null && cat != 'null')
    	$.ajax({ url: '/proposals/endless_index?category='+cat+'&page=' + currentPage, type:'get'});
  	else
		$.ajax({ url: '/proposals/endless_index?page=' + currentPage, type:'get'});
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
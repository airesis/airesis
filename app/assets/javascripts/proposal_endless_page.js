/**
 * @author coorasse
 */
var currentPage = 1;

function resetCounter () {
	currentPage = 1;
}

function checkScroll() {
//console.log('check scroll');
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
	distance = scrollDistanceFromBottom()
	//console.log('distance: ' + distance)
  return distance < 150;
}

function pageHeight() {
	//console.log('document.body.scrollHeight: ' + document.body.scrollHeight)
	//console.log('document.body.offsetHeight: ' +document.body.offsetHeight)
	pageH = Math.max(document.body.scrollHeight, document.body.offsetHeight)
	//console.log('pageHeight: ' + pageHeight)
  return pageH;
}

function scrollDistanceFromBottom(argument) {
	//console.log('window.pageYOffset: ' + window.pageYOffset)
	//console.log('self.innerHeight: ' + self.innerHeight)
  return pageHeight() - (window.pageYOffset + self.innerHeight);
}



$(function() {
  checkScroll();
});
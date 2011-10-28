/**
 * @author coorasse
 */
var currentPage = 1;

function checkScroll() {
  if (nearBottomOfPage()) {
    currentPage++;
	$.ajax({ url: '?page=' + currentPage, type:'get'});
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
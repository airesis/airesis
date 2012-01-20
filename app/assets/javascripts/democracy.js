$(function() {
	disegnaBottoni();
});
function disegnaBottoni() {
	$('.buttonStyle').button();
	$('.editButton').button({icons : {primary : "ui-icon-pencil"},text : false});
	$('.deleteButton').button({icons : {primary : "ui-icon-circle-close"},text : false});
}

function deleteMe(el) {
	$(el).remove();
}

var geocoder;
var map;

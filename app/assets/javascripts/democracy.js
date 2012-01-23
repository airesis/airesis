$(function() {
	disegnaBottoni();
	
});
function disegnaBottoni() {
	$('.buttonStyle').button();
	$('.editButton').button({icons : {primary : "ui-icon-pencil"},text : false});
	$('.deleteButton').button({icons : {primary : "ui-icon-circle-close"},text : false});
	$('.newButton').button({icons : {primary : "ui-icon-plusthick"}});
}

function disegnaDatePicker() {
	$(".datePicker").datepicker({
        dateFormat : "dd/mm/yy",
        buttonImageOnly : true,
        buttonImage : "<%= asset_path('iconDatePicker.gif') %>",
        showOn : "both",
        changeMonth : true,
        changeYear : true,
        yearRange : "c-1:c+10",
        duration: "",  
        showTime: true,  
        constrainInput: false,
        stepMinutes: 5,  
        stepHours: 1,  
        altTimeField: "alt",  
        time24h: true
   });
 }

function deleteMe(el) {
	$(el).remove();
}

var geocoder;
var map;

/**
 * Italian translation for bootstrap-datetimepicker
 * Enrico Rubboli <rubboli@gmail.com>
 */
;(function($){
	$.fn.fdatetimepicker.dates['it-IT'] = {
		days: ["Domenica", "Lunedi", "Martedi", "Mercoledi", "Giovedi", "Venerdi", "Sabato", "Domenica"],
		daysShort: ["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"],
		daysMin: ["Do", "Lu", "Ma", "Me", "Gi", "Ve", "Sa", "Do"],
		months: ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"],
		monthsShort: ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"],
		today: "Oggi",
		suffix: [],
		meridiem: [],
		weekStart: 1,
		format: "dd/mm/yyyy hh:ii",
		dateFormat: "dd/mm/yyyy",
        autoclose: true
	};

    $.fn.fdatetimepicker.defaults = $.fn.fdatetimepicker.dates['it-IT'];
}(jQuery));

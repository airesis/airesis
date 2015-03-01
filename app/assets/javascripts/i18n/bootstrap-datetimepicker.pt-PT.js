/**
 * Portuguese translation for bootstrap-datetimepicker
 * Original code: Cauan Cabral <cauan@radig.com.br>
 * Tiago Melo <tiago.blackcode@gmail.com>
 */
;(function($){
	$.fn.fdatetimepicker.dates['pt-PT'] = {
		days: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"],
		daysShort: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"],
		daysMin: ["Do", "Se", "Te", "Qu", "Qu", "Se", "Sa", "Do"],
		months: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"],
		monthsShort: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
		suffix: [],
		meridiem: ["am","pm"],
		today: "Hoje",
        format: "dd/mm/yyyy hh:ii",
        formatDate: "dd/mm/yyyy"
	};
    $.fn.fdatetimepicker.defaults = $.fn.fdatetimepicker.dates['pt-PT'];
}(jQuery));

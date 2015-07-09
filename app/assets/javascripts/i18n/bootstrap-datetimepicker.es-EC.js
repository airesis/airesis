/**
 * Spanish translation for bootstrap-datetimepicker
 * Bruno Bonamin <bruno.bonamin@gmail.com>
 */
(function ($) {
    $.fn.fdatetimepicker.dates['es-EC'] = {
        days: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"],
        daysShort: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"],
        daysMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"],
        months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
        today: "Hoy",
        suffix: [],
        meridiem: [],
        format: "dd/mm/yyyy hh:ii",
        formatDate: "dd/mm/yyyy"
    };
    $.fn.fdatetimepicker.defaults = $.fn.fdatetimepicker.dates['es-EC'];
}(jQuery));

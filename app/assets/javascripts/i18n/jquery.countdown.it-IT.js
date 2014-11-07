/* http://keith-wood.name/countdown.html
 * Italian initialisation for the jQuery countdown extension
 * Written by Davide Bellettini (davide.bellettini@gmail.com) and Roberto Chiaveri Feb 2008. */
(function($) {
	$.countdown.regionalOptions['it-IT'] = {
		labels: ['anni', 'mesi', 'settimane', 'giorni', 'ore', 'minuti', 'secondi'],
		labels1: ['anno', 'mese', 'settimana', 'giorno', 'ora', 'minuto', 'secondo'],
		compactLabels: ['a', 'm', 's', 'g'],
		whichLabels: null,
		digits: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
		timeSeparator: ':', isRTL: false};
	$.countdown.setDefaults($.countdown.regionalOptions['it-IT']);
})(jQuery);

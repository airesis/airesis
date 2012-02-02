// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/events/"+event.id +"/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/"+event.id+"/resize"
    });
}

function showEventDetails(event){
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")' class='buttonStyle'>Modifica</a>");
	$('#edit_event').append("<a href = '/events/"+event.id+"' class='buttonStyle'>Vai alla pagina</a>");
    if (event.recurring) {
        title = event.title + " (Ricorrente)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")' class='buttonStyle'>Cancella solo questa occorrenza</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")' class='buttonStyle'>Cancella tutte le occorrenze</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")' class='buttonStyle'>Cancella tutte le occorrenze future</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")' class='buttonStyle'>Cancella</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 700,
        close: function(event, ui){
        	$('#event_desc').empty();
            $('#desc_dialog').dialog('destroy')
        }
        
    });
    disegnaBottoni();
}


function editEvent(event_id){
    jQuery.ajax({
        dataType: 'script',
        type: 'get',
        url: "/events/"+ event_id+"/edit"
    });
}

function deleteEvent(event_id, delete_all){
	if (confirm('Sei sicuro di voler cancellare questo evento?')) {
    jQuery.ajax({
        data: 'delete_all='+delete_all,
        dataType: 'script',
        type: 'DELETE',
        url: "/events/"+event_id
    });
   }
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Ogni giorno':
            $('#period').html('giorni');
            $('#frequency').show();
            break;
        case 'Ogni settimana':
            $('#period').html('settimane');
            $('#frequency').show();
            break;
        case 'Ogni mese':
            $('#period').html('mesi');
            $('#frequency').show();
            break;
        case 'Ogni anno':
            $('#period').html('anni');
            $('#frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }
}

function showPlace(value){

    switch (value) {
        case '2':
	        $('#luogo').hide();
	        $('#map_canvas').hide();
            break;        
        default:
            $('#luogo').show();
            $('#map_canvas').show();
    }
}



/**
 * Gestione mappa
 */


	
var geocoder;
var map; //la mappa di google
var marker; //il marcatore della posizione
var basename = "event_meeting_attributes_place_attributes_";
	

/**
 * posiziona il marcatore sull'indirizzo specificato nel campo 'Comune'
 */
function codeAddress(id) {
	var comune = $('#' + id + ' .token-input-list .token-input-token p').html();
	if (comune != null) {
		var address = comune + ", " + document.getElementById(basename + "address").value;
		putMarker(address);
	}
}

/**
 * Posiziona il marcatore in un indirizzo specifico
 */
function putMarker(address) {
	geocoder.geocode({
		'address' : address
	}, function(results, status) {
		if(status == google.maps.GeocoderStatus.OK) {
			posizionaMappa(results[0].geometry.location,results[0].geometry.viewport);          
			listenMarkerPosition();					
		} else {
			alert("Impossibile utilizzare il geocoder di Google: " + status);
		}
	});
}

function posizionaMappa(latlng,viewport) {
	map.setCenter(latlng);
	marker.setPosition(latlng);	
	map.fitBounds(viewport);
}

function listenMarkerPosition() {
	var location = marker.getPosition();
	$('#' + basename + "latitude_original").val(location.lat());
	$('#' + basename + "longitude_original").val(location.lng());
}


function listenCenterChanged() {
	$('#' + basename + "latitude_center").val(map.getCenter().lat());
	$('#' + basename + "longitude_center").val(map.getCenter().lng());	
}

function listenZoomChanged() {	
	$('#' + basename + "zoom").val(map.getZoom());
	
}

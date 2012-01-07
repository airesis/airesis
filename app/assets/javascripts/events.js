// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
	alert('moving');
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
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Modifica</a>");
	$('#edit_event').append("<a href = '/events/"+event.id+"'>Vai alla pagina</a>");
    if (event.recurring) {
        title = event.title + " (Ricorrente)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Cancella solo questa occorrenza</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")'>Cancella tutte le occorrenze</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")'>Cancella tutte le occorrenze future</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Cancella</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy')
        }
        
    });
    
}


function editEvent(event_id){
    jQuery.ajax({
        dataType: 'script',
        type: 'get',
        url: "/events/"+ event_id+"/edit"
    });
}

function deleteEvent(event_id, delete_all){
    jQuery.ajax({
        data: 'delete_all='+delete_all,
        dataType: 'script',
        type: 'post',
        url: "/events/"+event_id+"/destroy"
    });
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
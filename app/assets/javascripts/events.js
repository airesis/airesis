function moveEvent(event, dayDelta, minuteDelta, allDay) {
    jQuery.ajax({
        data: 'title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/events/" + event.id + "/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta) {
    jQuery.ajax({
        data: 'title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/" + event.id + "/resize"
    });
}

function goEventPage(event) {
    window.location = event.url;
}

function showEventDetails(event) {
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ",this)' class='btn disable'>Modifica</a>");
    $('#edit_event').append("<a href = '/events/" + event.id + "' class='btn'>Vai alla pagina</a>");
    if (event.recurring) {
        title = event.title + " (Ricorrente)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")' class='btn'>Cancella solo questa occorrenza</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")' class='btn'>Cancella tutte le occorrenze</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")' class='btn'>Cancella tutte le occorrenze future</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")' class='btn'>Cancella</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 700,
        close: function (event, ui) {
            $('#event_desc').empty();
            $('#desc_dialog').dialog('destroy')
        }

    });
    $('#event_actions').show();
    disegnaBottoni();
}


function editEvent(event_id, src) {
    _this = $(src);
    $.ajax({
        dataType: 'script',
        type: 'get',
        url: "/events/" + event_id + "/edit",
        beforeSend: function (ev) {
            hideDisableButton(_this);
        },
        complete: function (ev) {
            showDisableButton(_this);
        }
    });
}

function deleteEvent(event_id, delete_all) {
    if (confirm('Sei sicuro di voler cancellare questo evento?')) {
        $.ajax({
            data: 'delete_all=' + delete_all,
            dataType: 'script',
            type: 'DELETE',
            url: "/events/" + event_id
        });
    }
}

function showPeriodAndFrequency(value) {

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

function showPlace(value) {
    switch (value) {
        case '2':   //votazione
            $('#luogo').hide();
            $('#create_map_canvas').hide();
            $('#elezione').hide();
            break;
        case '4':   //elezione
            $('#luogo').hide();
            $('#create_map_canvas').hide();
            $('#elezione').show();
            break;
        default:
            $('#luogo').show();
            $('#create_map_canvas').show();
            $('#elezione').hide();
    }
}


var delay = (function () {
    var timer = 0;
    return function (callback, ms) {
        clearTimeout(timer);
        timer = setTimeout(callback, ms);
    };
})();

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
    delay(function () {
        var comune = $('#' + id + ' .token-input-list .token-input-token p').html();
        if (comune != null) {
            var address = comune + ", " + document.getElementById(basename + "address").value;
            putMarker(address);
        }
    }, 600);
}


var marker_cache = {}
/**
 * Posiziona il marcatore in un indirizzo specifico
 */
function putMarker(address) {
    if (marker_cache[address] == null) {
        console.log('no cache');
        $('.loading_place').show();
        geocoder.geocode({
            'address': address
        }, function (results, status) {

            if (status == google.maps.GeocoderStatus.OK) {
                marker_cache[address] = results;
                posizionaMappa(results[0].geometry.location, results[0].geometry.viewport);
                listenMarkerPosition();
                $('.loading_place').hide();
            }
            else if (status == google.maps.GeocoderStatus.ZERO_RESULTS) {
                //alert('Spiacente ma non riesco a trovare l\'indirizzo. Prova a cambiarlo...');
            }
            else {
                //alert("Impossibile utilizzare il geocoder di Google: " + status);
            }
        });
    }
    else {
        console.log('cache');
        posizionaMappa(marker_cache[address][0].geometry.location, marker_cache[address][0].geometry.viewport);
        listenMarkerPosition();
    }
}

function posizionaMappa(latlng, viewport) {
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


function confirmEventData(el) {
    var event_form = $(el).closest('form');
    var valid = true;

    $('[data-validate]:input:visible', event_form).each(function () {
        var settings = window.ClientSideValidations.forms[this.form.id];
        if (!$(this).isValid(settings.validators)) {
            valid = false;
        }
    });
    if (valid) {
        if ($('#event_event_type_id').val() == 4) {
            var event_duration = et.eventEndTime - et.eventStartTime;
            var candidates_duration = et.candidatesTime - et.eventStartTime;
            var election_duration = et.eventEndTime - et.candidatesTime;
            if (event_duration <= 0 || candidates_duration <= 0 || election_duration <= 0) {
                alert('Le date non sono impostate correttamente. Ricontrollale.');
                return false;
            }
            else {
                return confirm('Durata evento: ' + secondsToString(event_duration / 1000) + ', durata iscrizioni: ' + secondsToString(candidates_duration / 1000) + ', durata votazione: ' + secondsToString(election_duration / 1000) + '. Sei sicuro?');
            }
        }
        else {
            return true;
        }
    }
    else {
        return false;
    }
}

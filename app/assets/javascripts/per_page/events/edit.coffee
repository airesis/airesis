window.EventsEdit =
  init: ->
    start_end_fdatetimepicker $('#event_starttime'), $("#event_endtime")
    @initMunicipalityInput()
    @initClientSideValidation()
    @initMapManager()
    if EventsEdit.votation
      @showPlace('2')
    if $('#event_all_day').is(':checked')
      fdatetimepicker_only_date $('#event_starttime'), $("#event_endtime")
  showPlace: (value)->
    switch value
      when '2'  #votazione
        $('#luogo').hide()
        $('#create_map_canvas').hide()
      else
        $('#luogo').show()
        $('#create_map_canvas').show()
  initClientSideValidation: ->
    window.ClientSideValidations.selectors =
      inputs: ':input:not(button):not([type="submit"])[name]:enabled'
      validate_inputs: ':input:enabled:visible[data-validate], .select2-container:visible ~ :input:enabled[data-validate]'
      forms: 'form[data-validate]'
    $('#edit_event_' + EventsEdit.eventId).enableClientSideValidations()
  initMunicipalityInput: ->
    Airesis.select2town($('#event_meeting_attributes_place_attributes_municipality_id'))
  initMapManager: =>
    if EventsEdit.placeDefined
      latlng = new (google.maps.LatLng)(EventsEdit.latitudeOriginal, EventsEdit.longitudeOriginal)
      center = new (google.maps.LatLng)(EventsEdit.latitudeCenter, EventsEdit.longitudeCenter)
      EventsEdit.mapManager = new Airesis.MapManager('edit_map_canvas', latlng, center, @zoom)
    else
      EventsEdit.mapManager = new Airesis.MapManager('edit_map_canvas')

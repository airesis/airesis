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
    new AiresisFormValidation($('#edit_event_' + EventsEdit.eventId))
  initMunicipalityInput: ->
    input = $('#event_meeting_attributes_place_attributes_municipality_id')
    Airesis.select2town(input)
    input.change (e)->
      $('#edit_event_' + EventsEdit.eventId).formValidation('revalidateField', input)
  initMapManager: =>
    if EventsEdit.placeDefined
      latlng = new (google.maps.LatLng)(EventsEdit.latitudeOriginal, EventsEdit.longitudeOriginal)
      center = new (google.maps.LatLng)(EventsEdit.latitudeCenter, EventsEdit.longitudeCenter)
      EventsEdit.mapManager = new Airesis.MapManager('edit_map_canvas', latlng, center, @zoom)
    else
      EventsEdit.mapManager = new Airesis.MapManager('edit_map_canvas')

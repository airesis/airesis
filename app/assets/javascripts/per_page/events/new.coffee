window.EventsNew =
  init: ->
    start_end_fdatetimepicker $('#event_starttime'), $("#event_endtime");
    @initMunicipalityInput()

    $('.legend').hide()
    @initMapManager()

    $('#new_event').quickWizard
      prevButton: '<button id="form-wizard-prev" type="button" class="btn"><i class="fa fa-arrow-left"></i>' + Airesis.i18n.buttons.goBack + '</button>'
      nextButton: '<button id="form-wizard-next" type="button" class="btn blue"><i class="fa fa-arrow-right"></i>' + Airesis.i18n.buttons.next + '</button>'
      nextCallback: ->
        setTimeout (->
          EventsNew.mapManager.refresh()
          return
        ), 1000
        return
      prevCallback: ->
    window.ClientSideValidations.selectors =
      inputs: ':input:not(button):not([type="submit"])[name]:enabled'
      validate_inputs: ':input:enabled:visible[data-validate], .select2-container:visible ~ :input:enabled[data-validate]'
      forms: 'form[data-validate]'
    $('#new_event').enableClientSideValidations()
    $('#create_event_dialog').foundation('reveal', 'open', {
      closeOnBackgroundClick: false,
      closeOnEsc: false
    })
  initMunicipalityInput: ->
    Airesis.select2town($('#event_meeting_attributes_place_attributes_municipality_id'))
  initMapManager: ->
    if !EventsEdit.votation
      EventsNew.mapManager = new Airesis.MapManager('create_map_canvas')

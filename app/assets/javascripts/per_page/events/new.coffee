window.EventsNew =
  init: ->

    form = $('#new_event')
    form.data('formValidation').destroy()

    form.steps
      headerTag: ".legend"
      bodyTag: ".step"
      autoFocus: true
      labels: {
        previous: '<i class="fa fa-arrow-left"></i>' + Airesis.i18n.buttons.goBack
        next: '<i class="fa fa-arrow-right"></i>' + Airesis.i18n.buttons.next
      }
      onStepChanging: (e, currentIndex, newIndex)->
        fv = form.data('formValidation')
        $container = form.find('.step.current')
        fv.validateContainer($container);
        isValidStep = fv.isValidContainer($container)
        !(isValidStep is false || isValidStep is null)
      onStepChanged: (event, currentIndex, priorIndex)->
        setTimeout (->
          EventsNew.mapManager.refresh()
          return
        ), 1000
      onFinishing: (e, currentIndex)->
        fv = form.data('formValidation')
        $container = form.find('.step.current')
        fv.validateContainer($container)
        isValidStep = fv.isValidContainer($container)
        !(isValidStep is false || isValidStep is null)
      onFinished: (e, currentIndex)->
        form.formValidation('defaultSubmit')

    $('#create_event_dialog').foundation('reveal', 'open', {
      closeOnBackgroundClick: false,
      closeOnEsc: false
    })

    start_end_fdatetimepicker $('#event_starttime'), $("#event_endtime");
    @initMunicipalityInput()
    @initMapManager()

    new AiresisFormValidation(form)
  initMunicipalityInput: ->
    input = $('#event_meeting_attributes_place_attributes_municipality_id')
    Airesis.select2town(input)
    input.change (e)->
      $('#new_event').formValidation('revalidateField', input.attr('name'))
  initMapManager: ->
    if !EventsEdit.votation
      EventsNew.mapManager = new Airesis.MapManager('create_map_canvas')

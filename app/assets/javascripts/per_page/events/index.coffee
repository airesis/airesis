window.EventsIndex =
  init: ->
    $('.create_event').on 'click', ->
      create_event_ = $('#create_event_dialog')
      create_event_.empty()
      create_event_.append $('.choose_event_type').clone().show()
      $('.event_model_option', create_event_).click ->
        create_event_inner_ = $('.choose_event_type', create_event_)
        type_id = $(this).data('id')
        create_event_inner_.hide 1000, ->
          create_event_inner_.remove()
          create_event_.append EventsIndex.loadingFragment
          $.ajax
            url: EventsIndex.newEventUrl
            data: event_type_id: type_id
            dataType: 'script'
          return
        return
      create_event_.foundation 'reveal', 'open',
        closeOnBackgroundClick: false
        closeOnEsc: false
      false
    $(window).resize ->
      $('#calendar').fullCalendar 'option', 'height', $(window).height() - 170
      return
    fullCalendarOptions =
      editable: true
      height: $(window).height() - 185
      header:
        left: 'today prev,next'
        center: 'title'
        right: 'list,month,agendaWeek,agendaDay'
      eventLimit: true
      views: month: eventLimit: 4
      defaultView: 'month'
      slotMinutes: 15
      events: EventsIndex.eventsUrl
      columnFormat:
        month: 'ddd'
        week: 'ddd M/D'
        day: 'dddd'
      axisFormat: 'H:mm'
      dragOpacity: '0.5'
      eventDrop: (event, delta, revertFunc, jsEvent, ui, view) ->
        jQuery.ajax
          data:
            day_delta: delta.days()
            minute_delta: delta.minutes()
          dataType: 'script'
          type: 'post'
          url: "/events/#{event.id}/move"
      eventResize: (event, delta, revertFunc, jsEvent, ui, view) ->
        jQuery.ajax
          data:
            day_delta: delta.days()
            minute_delta: delta.minutes()
          dataType: 'script'
          type: 'post'
          url: "/events/#{event.id}/resize"
      eventClick: (event, jsEvent, view) ->
        window.location = event.url
      eventRender: (event, element) ->
        if event.editable
          element.css 'cursor', 'pointer'
        return
    fullCalendarOptions = $.extend(fullCalendarOptions, EventsIndex.calendarI18n)
    if EventsIndex.createEvent
      fullCalendarOptions = $.extend(fullCalendarOptions, dayClick: (date, jsEvent, view) ->
        $.ajax
          data:
            starttime: date.valueOf()
            has_time: date.hasTime()
            event_type_id: EventsIndex.defaultEventType
          url: EventsIndex.newEventUrlClick
          dataType: 'script'
        return
      )
    else
      fullCalendarOptions = $.extend(fullCalendarOptions,
        disableDragging: true
        disableResizing: true)
    $('#calendar').fullCalendar fullCalendarOptions
    if EventsIndex.autoOpen
      $.ajax
        url: EventsIndex.autoOpenUrl
        dataType: 'script'

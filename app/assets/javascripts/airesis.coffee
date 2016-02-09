window.Airesis = {
  i18n: {}
  scrollLock: (element, event)->
    d = event.originalEvent.wheelDelta || -event.originalEvent.detail
    dir = if d > 0 then 'up' else 'down'
    stop = (dir is 'up' && element.scrollTop is 0) || (dir is 'down' && element.scrollTop is element.scrollHeight - element.offsetHeight)
    stop && event.preventDefault()
    return
  development: ->
    @environment is 'development'
  log: (args)->
    console.log args if Airesis.development()
  select2town: (element)->
    element.select2
      placeholder: Airesis.i18n.type_for_town
      ajax:
        url: '/municipalities'
        dataType: 'json'
        data: (params) ->
          {
          q: params.term
          }
        processResults: (data, page) ->
          {results: data}
        cache: true
      escapeMarkup: (m) ->
        m
  delay: do ->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
      return
}

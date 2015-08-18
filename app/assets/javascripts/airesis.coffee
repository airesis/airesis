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
      cacheDataSource: []
      placeholder: Airesis.i18n.type_for_town
      query: (query) ->
        _self = this
        key = query.term
        cachedData = _self.cacheDataSource[key]
        if cachedData
          query.callback results: cachedData
          return
        else
          $.ajax
            url: '/municipalities'
            data:
              q: query.term
              l: Airesis.i18n.locale
            dataType: 'json'
            type: 'GET'
            success: (data) ->
              _self.cacheDataSource[key] = data
              query.callback results: data
              return
        return
      escapeMarkup: (m) ->
        m
    element.select2('data', element.data('pre'))
    return
  delay: do ->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
      return
}

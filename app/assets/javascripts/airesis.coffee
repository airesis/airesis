window.Airesis = {
  i18n: {}
  scrollLock: (element,event)->
    d = event.originalEvent.wheelDelta || -event.originalEvent.detail
    dir = if d > 0 then 'up' else 'down'
    stop = (dir is 'up' && element.scrollTop is 0) || (dir is 'down' && element.scrollTop is element.scrollHeight - element.offsetHeight)
    stop && event.preventDefault()
    return
}

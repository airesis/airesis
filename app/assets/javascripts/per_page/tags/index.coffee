window.TagsIndex =
  init: ->
    $('[data-tag-cloud] a').qtip
      position:
        at: 'bottom center'
        my: 'top center'
      style:
        classes: 'qtip-light qtip-shadow'

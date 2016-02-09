$ ->
  $('.language.footer').qtip
    position:
      at: 'top center'
      my: 'bottom center'
      viewport: $(window)
    style: classes: 'qtip-shadow qtip-light'
    show:
      event: 'click mouseenter'
      solo: true
    hide: event: 'click mouseleave'

  $('#language').on 'opened', ->
    $(this).find('.row a').qtip
      style: classes: 'qtip-shadow qtip-light'
      position:
        at: 'left center'
        my: 'right center'
    $(this).foundation 'section', 'reflow'

window.ProposalsIndex =
  init: ->
    $('[name="time[start_w]"],[name="time[end_w]"]').fdatetimepicker
      format: $.fn.fdatetimepicker.defaults.dateFormat
    $('.creation_date').each ->
      if ProposalsIndex.timeFilter?
        selected_ = $(this).find('.hidden_menu a[data-type=' + ProposalsIndex.timeFilter.type + ']')
        if ProposalsIndex.timeFilter.type is 'f'
          text = ProposalsIndex.timeFilter.start_w + ' - ' + ProposalsIndex.timeFilter.end_w
        else
          text = selected_.text()
      else
        selected_ = $(this).find('.hidden_menu a[data-type=w]')
        text = selected_.text()
      $(this).find('.hidden_link b').text(text)
      selected_.addClass('checked')
    $('html').click ->
      $('.hidden_menu').hide()
      $('.hidden_link.visible').removeClass('visible')
    $('.hidden_link').click (event)->
      $(this).addClass('visible')
      $(this).next().show().position
        my: "right top"
        at: "right bottom"
        of: $(this)
      event.stopPropagation()

    input = $('.interest_borders')

    input.select2
      placeholder: Airesis.i18n.interestBorders.hintText
      allowClear: true
      ajax:
        url: '/interest_borders'
        dataType: 'json'
        delay: 250
        data: (params) ->
          {
          q: params.term
          l: Airesis.i18n.locale
          pp: 'disable'
          }
        processResults: (data, page) ->
          { results: data }
        cache: true
      escapeMarkup: (markup) ->
        markup
      minimumInputLength: 1
    .on "change", (e)->
      @.closest('form').submit()

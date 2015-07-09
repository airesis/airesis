window.ProposalsIndex =
  init: ->
    $("[data-href=#{@hash_tab_value()}]").addClass('active')
    @mytabCallback()
    $('#proposals-tabs').on 'toggled', (event, tab)=>
      @mytabCallback()
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
    input.tokenInput "/interest_borders.json",
      crossDomain: false
      prePopulate: input.data("pre")
      hintText: Airesis.i18n.interestBorders.hintText
      noResultsText: Airesis.i18n.interestBorders.noResultsText
      searchingText: Airesis.i18n.interestBorders.searchingText
      preventDuplicates: true
      tokenLimit: 1
      allowTabOut: true
      onAdd: ->
        @.closest('form').submit()
      onDelete: ->
        @.closest('form').submit()
  active_tab: ->
    $('#proposals-tabs').find('.active')
  hash_tab_value: ->
    uri = new URI()
    if uri.fragment() then uri.fragment().replace('_', '') else 'debate'
  mytabCallback: ->
    obj = ProposalsIndex.active_tab()
    active_ = $('#proposals-content .content.active')
    if !obj.data('ititialized')
      url_ = obj.find('a').attr('data-href')
      $.ajax
        dataType: 'html'
        url: url_
        complete: (data)->
          target = active_
          target.html(data.responseText)
          obj.data('ititialized', true)
    window.location.hash = obj.find('a').attr('href').replace('#', '_')

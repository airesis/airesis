window.ProposalsIndex =
  init: ->
    $("[data-href=#{@hash_tab_value()}]").addClass('active')
    $('#proposals-tabs').on 'toggled', (event, tab)->
      ProposalsIndex.mytabCallback
    ProposalsIndex.mytabCallback
    $(window).on 'hashchange', ->
      ProposalsIndex.hashChange()
    datePickerOptions =
      changeMonth: false
      changeYear: false
      yearRange: "c:c+10"
      maxDate: 0
      duration: ""
      showTime: true
      constrainInput: true
      stepMinute: 5
      stepHour: 1
      altTimeField: "alt"
      time24h: true
    $('[name="time[start_w]"]').fdatetimepicker
      format: $.fn.fdatetimepicker.defaults.dateFormat
    $('[name="time[end_w]"]').fdatetimepicker
      format: $.fn.fdatetimepicker.defaults.dateFormat

    $('.creation_date').each ->
      if ProposalsIndex.timeFilter isnt ''
        selected_ = $(this).find('.hidden_menu a[data-type=' + ProposalsIndex.timeFilter.type + ']')
        if ProposalsIndex.timeFilter.type is 'f'
          $(this).find('.hidden_link b').text(ProposalsIndex.timeFilter.start_w + ' - ' + ProposalsIndex.timeFilter.end_w)
        else
          $(this).find('.hidden_link b').text(selected_.text())

      else
        selected_ = $(this).find('.hidden_menu a[data-type=w]')
        $(this).find('.hidden_link b').text(selected_.text())
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
    $('#nuova_proposta, #nuovo_sondaggio').bind "ajax:error", (event, data, status, xhr)->
      if data.status == 401
        window.location = "/users/sign_in?l=#{Airesis.i18n.locale}"
    url = document.URL;
    hashValue = url.substring(url.indexOf('#')).replace('#', '');
    $('#tabs').tabs("option", "active", hashValue)
  active_tab: ->
    $('#proposals-tabs').find('.active')
  hash_tab_value: ->
    uri = new URI()
    uri.fragment() || 'debate'
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

    window.location.hash = obj.find('a').attr('href').replace('#', '')
  hashChange: ->

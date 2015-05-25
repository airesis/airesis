$ ->

  checkCharacters = (field) ->
    button = $(this).nextAll('.search-by-text')
    if field.val().length > 1
      button.removeAttr 'disabled'
      true
    else
      button.attr 'disabled', 'disabled'
      false

  ClientSideValidations.selectors.validate_inputs += ', .select2-container:visible :input:enabled[data-validate]'
  $(document).foundation()
  Facebook.load()
  if Airesis.env == 'production'
    GoogleAnalytics.load()
  if Airesis.env == 'test'
    $.fx.off = true
  #polling alerts
  if Airesis.signed_in
    PrivatePub.subscribe '/notifications/' + Airesis.id, (data, channel) ->
      if Airesis.resource_viewable
        #if I am in a page with a viewable object, sign it has view and then poll for alerts
        $.ajax
          url: window.location
          complete: poll_if_not_recent
      else
        #otherwise, just poll for alerts
        poll_if_not_recent()
      return
    poll()
  #feedback configuration
  feedback_options = Feedback(
    h2cPath: Airesis.i18n.feedback.h2cPath
    url: '/send_feedback'
    label: Airesis.i18n.feedback.label
    header: Airesis.i18n.feedback.header
    nextLabel: Airesis.i18n.feedback.nextLabel
    reviewLabel: Airesis.i18n.feedback.reviewLabel
    sendLabel: Airesis.i18n.feedback.sendLabel
    closeLabel: Airesis.i18n.feedback.closeLabel
    messageSuccess: Airesis.i18n.feedback.messageSuccess
    messageError: Airesis.i18n.feedback.messageError
    appendTo: $('footer .feedback_space')[0]
    btnClass: 'feedbackBtn'
    pages: [
      new (window.Feedback.Form)([ {
        type: 'textarea'
        name: 'message'
        label: Airesis.i18n.feedback.describeProblem
        required: true
      } ])
      new (window.Feedback.Screenshot)(
        h2cPath: Airesis.i18n.feedback.h2cPath
        blackoutButtonMessage: Airesis.i18n.feedback.blackoutButtonMessage
        highlightButtonMessage: Airesis.i18n.feedback.highlightButtonMessage
        highlightOrBlackout: Airesis.i18n.feedback.highlightOrBlackout)
      new (window.Feedback.Review)
    ])
  #remove attributes for introjs from aside hidden menu. so they can work correctly
  $('aside [data-ijs]').removeAttr 'data-ijs'
  ClientSideValidations.selectors.validate_inputs += ', .select2-container:visible ~ :input:enabled[data-validate]'
  $.fn.qtip.defaults = $.extend(true, {}, $.fn.qtip.defaults, style: classes: 'qtip-light qtip-shadow')
  $viewport = $('html, body')
  disegnaProgressBar()
  if $('.sticky-anchor').length > 0
    $(window).scroll sticky_relocate
    sticky_relocate()
  $('#menu-group .menu-activator').click ->
    menu_ = $('#menu-left')
    if menu_.attr('data-expshow') == 'true'
      menu_.removeClass 'small-show'
      menu_.attr 'data-expshow', false
    else
      menu_.addClass 'small-show'
      menu_.attr 'data-expshow', true
    return
  mybox_animate()
  searchcache = {}
  search_f = $('#search_q')
  if search_f.length > 0
    search_f.autocomplete
      minLength: 1
      source: (request, response) ->
        term = request.term
        if term of searchcache
          response searchcache[term]
          return
        $.getJSON '/searches', request, (data, status, xhr) ->
          searchcache[term] = data
          response data
          return
        return
      focus: (event, ui) ->
        event.preventDefault()
        return
      select: (event, ui) ->
        window.location.href = ui.item.url
        event.preventDefault()
        return

    search_f.data('uiAutocomplete')._renderMenu = (ul, items) ->
      that = this
      $.each items, (index, item) ->
        if item.type == 'Divider'
          ul.append $('<li class=\'ui-autocomplete-category\'>' + item.value + '</li>')
        else
          that._renderItemData ul, item
        return
      $(ul).addClass('f-dropdown').addClass('medium').css('z-index', 1005).css 'width', '400px'
      return

    search_f.data('uiAutocomplete')._renderItem = (ul, item) ->
      el = $('<li>')
      link_ = $('<a></a>')
      container_ = $('<div class="search_result_container"></div>')
      image_ = $('<div class="search_result_image"></div>')
      container_.append image_
      desc_ = $('<div class="search_result_description"></div>')
      desc_.append '<div class="search_result_title">' + item.label + '</div>'
      text_ = $('<div class="search_result_text">' + '</div>')
      if item.type == 'Blog'
        image_.append item.image
        text_.append '<a href="' + item.user_url + '">' + item.username + '</a>'
      else if item.type == 'Group'
        text_.append '<div class="groupDescription"><img src="' + Airesis.assets.group_participants + '"><span class="count">' + item.participants_num + '</span></div>'
        text_.append '<div class="groupDescription"><img src="' + Airesis.assets.group_proposals + '"><span class="count">' + item.proposals_num + '</span></div>'
        image_.append '<img src="' + item.image + '"/>'
      else
        image_.append '<img src="' + item.image + '"/>'
      desc_.append text_
      container_.append desc_
      container_.append '<div class="clearboth"></div>'
      link_.attr 'href', item.url
      link_.append container_
      el.append link_
      el.appendTo ul
      el

  $('.submenu a div').qtip position:
    at: 'bottom center'
    my: 'top center'
    effect: false
  $('.cur.love').qtip
    position:
      at: 'bottom center'
      my: 'top center'
      viewport: $(window)
      effect: false
      adjust:
        method: 'shift'
        x: 0
        y: 0
    style: classes: 'qtip-light qtip-shadow qtip-cur'
    show: solo: true
  $('[data-qtip]').qtip style: classes: 'qtip-light qtip-shadow'
  $(document).on 'focus', '[data-datetimepicker]', ->
    $(this).fdatetimepicker()
    return
  $('input[data-datepicker]').fdatetimepicker format: $.fn.fdatetimepicker.defaults.dateFormat
  $(document).on 'click', '[data-reveal-close]', ->
    $('.reveal-modal:visible').foundation 'reveal', 'close'
    return
  $(document).on 'click', '[data-login]', ->
    'use strict'
    $('#login-panel').foundation 'reveal', 'open'
    false
  $('.create_proposal').on 'click', ->
    link = $(this)
    create_proposal_ = $('<div class="dynamic_container reveal-modal large" data-reveal></div>')
    create_proposal_.append $(this).next('.choose_model').clone().show()
    $('.proposal_model_option', create_proposal_).click ->
      create_proposal_inner_ = $('.choose_model', create_proposal_)
      type_id = $(this).data('id')
      create_proposal_inner_.hide 1000, ->
        create_proposal_inner_.remove()
        create_proposal_.append $('#loading-fragment').clone()
        $.ajax
          url: link.attr('href')
          data: 'proposal_type_id=' + type_id
          dataType: 'script'
        return
      return
    airesis_reveal create_proposal_
    false
  $.fn.tagcloud.defaults =
    size:
      start: 12
      end: 24
      unit: 'pt'
    color:
      start: '#fff'
      end: '#fff'
  $('[data-tag-cloud] a').tagcloud()
  #proposals index, search by text field
  $('.search-by-text').on 'click', ->
    field = $(this).prevAll('.field-by-text')
    condition = $(this).prevAll('.condition-for-text:checked')
    if checkCharacters(field)
      loc_ = addQueryParam(location.href, 'search', field.val())
      if condition.length > 0
        loc_ = addQueryParam(loc_, 'or', condition.val())
      else
        loc_ = addQueryParam(loc_, 'or', '')
      window.location = loc_
    false
  #initialize textntags when needed
  $(document).on 'focus', '[data-textntags]', ->
    if $(this).data('textntags') != 1
      $(this).textntags
        triggers: '@': uniqueTags: false
        onDataRequest: (mode, query, triggerChar, callback) ->
          data = ProposalsShow.nicknames
          query = query.toLowerCase()
          found = _.filter(data, (item) ->
            item.name.toLowerCase().indexOf(query) > -1
          )
          callback.call this, found
          return
      $(this).data 'textntags', 1
      $(this).focus()
    return
  #executes page specific js
  page = $('body').data('page')
  execute_page_js page
  return

window.ProposalsShow =
  voting: false
  contributesUrl: ''
  rightlistUrl: ''
  clicked: null
  contributes: []
  nicknames: []
  checkActive: false
  currentView:  3
  currentPage: 0
  proposalId: null
  openShare: false
  contributeMaxLength: 0
  times: {},
  firstCheck: false
  init: ->
    @currentView = if Airesis.signed_in then 1 else 3
    $('[data-scroll-to="vote_panel"]').on 'click', ->
      @scroll_to_vote_panel()
    $(document).on 'click', '[data-cancel-edit-comment]', ->
      ProposalsShow.cancel_edit_comment($(this).data('cancel-edit-comment'))
      return false
    $(document).on 'click', '[data-edit-contribute]', ->
      ProposalsShow.edit_contribute($(this).data('edit-contribute'))
      return false
    $(document).on 'click', '[data-history-contribute]', ->
      ProposalsShow.history_contribute($(this).data('history-contribute'))
      return false
    $(document).on 'click', '[data-report-contribute]', ->
      ProposalsShow.report_contribute($(this).data('report-contribute'))
      return false
    $(document).on 'click', '[data-close-section-id]', ->
      ProposalsShow.close_right_contributes($('.contribute-button[data-section_id=' + $(this).data('close-section-id') + ']'))
      return false
    $(document).on 'click', '[data-close-edit-right-section]', ->
      hideContributes()
      return false;
    $(document).on 'ajax:beforeSend', '.vote_comment', (n, xhr)->
      $(this).parent().find('.vote_comment').hide()
      $(this).parent().find('.loading').show()
    $(document).on 'ajax:beforeSend', '.votedown-mini', (n, xhr)->
      num = $(this).data('id')
      $(this).parent().find('.vote_comment').hide()
      $(this).parent().find('.loading').show()
      $(".reply_textarea[data-id=#{num}]").focus().attr('placeholder',
        'Indica il motivo della tua valutazione negativa').effect('highlight', {}, 3000)
    $(document).ajaxError (e, XHR, options)->
      if XHR.status == 401
        window.location.replace(Airesis.new_user_session_path)

    if @voting
      $('.vote_solution_title').each ->
        $(this).on 'click', ->
          scrollToElement $('.solution_main[data-solution_id=' + $(this).data('id') + ']')
          false
        $(this).qtip content: $('.proposal_content[data-id=' + $(this).data('id') + ']').clone()
      $('#schulze-submit').on 'click', ->
        vote = []
        votestring = ''
        $('[data-slider-input]').each ->
          val = $(this).val()
          id = $(this).data('slider-input')
          if !val or val == ''
            val = '0'
          vote.push [
            id
            val
          ]
          return
        vote.sort (a, b) ->
          parseInt(b[1]) - parseInt(a[1])
        for v of vote
          if v != '0'
            if vote[v][1] == vote[v - 1][1]
              votestring += ','
            else
              votestring += ';'
          votestring += vote[v][0]
        $('#data_votes').val votestring
        true
      $('.votebutton').on 'click', ->
        type = $(this).data('vote-type')
        message = if type == Airesis.i18n.proposals.vote.positive then Airesis.i18n.proposals.vote.confirm_positive else if type == Airesis.i18n.proposals.vote.neutral then Airesis.i18n.proposals.vote.confirm_neutral else Airesis.i18n.proposals.vote.confirm_negative
        if confirm(message)
          $('#data_vote_type').val type
          $('.votebutton').fadeOut()
          $('.vote_panel form').fadeOut()
          $('.loading_vote').show()
          $('.vote_panel form').submit()
        false
    else
      @currentPage++;
      $.ajax
        url: @contributesUrl,
        dataType: 'script',
        data: {
          page: @currentPage,
          view: @currentView,
          contributes: @contributes,
          comment_id: Airesis.show_comment_id #show contribute if requested
        },
        type: 'get',
        complete: ->
          $("#loading_contributes").hide();
    if @voted
      if matchMedia(Foundation.media_queries['medium']).matches
        $('.results-button')[0].click()

    $('img.cke_iframe').each ->
      realelement = $(this).data('cke-realelement')
      $(this).after($(unescape(realelement)))
      $(this).remove()

    @init_text_areas()
    @init_contributes_button()
    @init_countdowns()
    @initVotePeriodSelect()

    #open the contribute if it's a link from an email
    if Airesis.show_section_id
      $(".contribute-button[data-section_id=#{Airesis.show_section_id}]").trigger('click', [Airesis.show_comment_id])

    if @openShare isnt ''
      $('#promote_proposal').click();
  init_text_areas: ->
    $('[data-contribute-area]').each ->
      if $(this).attr('data-initialized') != 1
        $(this).textntags
          triggers: {'@': {uniqueTags: false}},
          onDataRequest: (mode, query, triggerChar, callback)->
            data = ProposalsShow.nicknames
            query = query.toLowerCase()
            found = _.filter data, (item)->
              return item.name.toLowerCase().indexOf(query) > -1
            callback.call(this, found);
        $(this).charCount
          allowed: ProposalsShow.contributeMaxLength
          warning: 100,
          counterText: Airesis.i18n.proposals.charactersLeft
        $(this).attr('data-initialized', 1);
  scroll_to_vote_panel: ->
    scrollToElement($(".vote_panel"))
    return false
  contribute: (section_id)->
    $('#proposal_comment_section_id').val(section_id)
    Airesis.viewport.animate({
        scrollTop: $("#proposal_comment_content").offset().top - 150
      }, 2000, ->
      $('#proposal_comment_content').focus()
      $('#comment-form-comment').effect('highlight', {}, 3000)
    )
    Airesis.viewport.bind "scroll mousedown DOMMouseScroll mousewheel keyup", (e)->
      if matchMedia(Foundation.media_queries['medium']).matches && e.which > 0 || e.type is "mousedown" || e.type is "mousewheel"
        Airesis.viewport.stop().unbind 'scroll mousedown DOMMouseScroll mousewheel keyup'
    return false
  edit_contribute: (id)->
    close_all_dropdown()
    $.ajax
      dataType: 'script',
      type: 'get',
      url: "/proposals/#{@proposalId}/proposal_comments/#{id}/edit"
    return false
  cancel_edit_comment: (id)->
    if confirm('Are you sure?')
      $('.proposalComment[data-id=' + id + '] .edit_panel').fadeOut ->
        $(this).remove()
        $('.proposalComment[data-id=' + id + '] .baloon-content').fadeIn()
  history_contribute: (id)->
    close_all_dropdown()
    $.ajax
      dataType: 'script',
      type: 'get',
      url: "/proposals/#{@proposalId}/proposal_comments/#{id}/history"
    return false;
  report_contribute: (id)->
    $('#report_contribute_id').val(id)
    $('input[name=reason]').removeAttr('checked')
    $('#report_contribute').foundation('reveal', 'open')
    close_all_dropdown()
  checkScroll: ->
    unless @voting
      if nearBottomOfPage() && @checkActive
        @checkActive = false;
        @currentPage++;
        $.ajax
          url: @contributesUrl,
          dataType: 'script',
          data: {
            page: @currentPage,
            view: @currentView,
            contributes: @contributes
          },
          type: 'get'
      else
        setTimeout("ProposalsShow.checkScroll()", 250)
  open_right_contributes: (_this, comment_id)->
    section_id = _this.attr("data-section_id")
    _this.attr("data-status", 1)
    $('#suggest').show()
    _this.parent().find(".tria").show()
    _this.parent().addClass("sel")
    $('.text', _this).text(Airesis.i18n.proposals.closeContributes)
    hideLeftPanel()
    fetched = $('.suggestion_right[data-section_id=' + section_id + ']')
    fitRightMenu(fetched)
    $('.suggestion_right[data-section_id=' + section_id + ']').fadeIn()
    _this.next().show()
    if comment_id
      comment_ = $('#comment' + comment_id + ' .proposal_comment')
      fetched.animate({
        scrollTop: comment_.offset().top - 100
      }, 2000)
      comment_.effect('highlight', {}, 3000)
  close_right_contributes: (_this)->
    section_id = _this.attr("data-section_id")
    _this.attr("data-status", 2)
    $('.suggestion_right[data-section_id=' + section_id + ']').hide()
    _this.parent().find(".tria").hide()
    $('.text',
      _this).text(Airesis.i18n.proposals.showGiveContributes).append(" (#{_this.attr('data-unread_contributes_num')}/#{_this.attr('data-contributes_num')})")
    $('#menu-left').removeClass('contributes_shown')
    $('#centerpanelextended').removeClass('contributes_shown')
    $('.suggestion_right[data-section_id=' + section_id + ']').removeClass('contributes_shown')
    _this.next().hide()
  reload_page: ->
    toastr.options = {tapToDismiss: false, extendedTimeOut: 0, timeOut: 0}
    toastr.info('<div>This page is outdate.<br/>Please reload the page.<br/><a href="" class="btn" style="color: #444">Reload</a></div>')
#0 - not fetched - closed
#1 - fetched - open
#2 - fetched - closed
  init_contributes_button: ->
    $(".contribute-button").click (event, comment_id)->
      this_ = $(this)
      section_id = this_.attr("data-section_id")
      this_status = this_.attr("data-status")
      $(".contribute-button").each ->
        his_status = $(this).attr("data-status")
        his_section_id = $(this).attr("data-section_id")
        if this_[0] != this     #for each right panel that is not the opened one
          if his_status is '1'
            $(this).attr("data-status", '2')
            $('.suggestion_right[data-section_id=' + his_section_id + ']').hide() #hide it
            $(this).parent().find(".tria").hide()
            $('.text',
              this).text(Airesis.i18n.proposals.showGiveContributes).append(" (" + $(this).attr('data-unread_contributes_num') + "/" + $(this).attr('data-contributes_num') + ")")
            $(this).next().hide() #and hide what comes next...i don't know really...

      $(".suggest .tria").hide()
      $(".suggest").removeClass("sel")
      if this_status is '0'  #closed and never fetched
        $(this).attr("data-status", '1')
        $('#suggest').show()
        $(this).parent().find(".tria").show()
        $(this).parent().addClass("sel")
        $('.text', this).text(Airesis.i18n.proposals.closeContributes)
        hideLeftPanel()
        fetched = $('<div data-section_id="' + section_id + '"class="suggestion_right"></div>')
        fetched.append('<div style="margin:auto;text-align:center;">' + Airesis.loadingImageTag + '<br/><b>' + Airesis.i18n.proposals.loadingContributes + '</b></div>')
        $('#centerpanelextended').append(fetched)
        fitRightMenu(fetched)
        $(this).next().show()
        $.ajax
          url: ProposalsShow.rightListUrl,
          data:
            comment_id: comment_id
            section_id: section_id
            disable_limit: true
            view: if Airesis.signed_in then 1 else 3
          ,
          type: 'get',
          dataType: 'script',
          complete: ->
            $(".loading", fetched).hide()
          ,
          error: (xhr, ajaxOptions, thrownError)->
            $(".loading", fetched).hide()
            if xhr.status == '404'
              $(fetched).html(Airesis.i18n.proposals.errorLoadingParagraph)
        $('.suggestion_right').bind 'mousewheel DOMMouseScroll', (e)->
          if matchMedia(Foundation.media_queries['medium']).matches
            Airesis.scrollLock(this,e)
        scrollToElement($(".proposal_main[data-section_id=#{section_id}]"))
      else if this_status is '2' #closed and fetched
        ProposalsShow.open_right_contributes($(this), comment_id)
        scrollToElement($(".proposal_main[data-section_id=#{section_id}]"))
      else #status == 1  fetched and open
        if comment_id?
          comment_ = $('#comment' + comment_id + ' .proposal_comment')
          section_id = $(this).attr("data-section_id")
          scrollToElement($(".proposal_main[data-section_id=#{section_id}]"))
        else
          ProposalsShow.close_right_contributes($(this))
      return false
  init_countdowns: ->
    creationDate = new Date(ProposalsShow.times.created_at * 1000)
    $('.date-creation').each ->
      $(this).countdown $.extend
        since: creationDate
        significant: 1
        format: 'YODHMS'
        layout: '{y<}{yn} {yl}{y>} {o<}{on} {ol}{o>} {d<}{dn} {dl}{d>} {h<}{hn} {hl}{h>} {m<}{mn} {ml}{m>}'
      ,
        $.countdown.regionalOptions[Airesis.i18n.locale]

    updateDate = new Date(ProposalsShow.times.updated_at * 1000)
    $('.date-update').countdown $.extend
      since: updateDate
      significant: 1
      format: 'YODHMS'
      layout: Airesis.i18n.countdown.layout2
    ,
      $.countdown.regionalOptions[Airesis.i18n.locale]

    endsDate = new Date(ProposalsShow.times.ends_at * 1000)
    $('.end-debate').countdown $.extend
      until: endsDate
      significant: 3
      onExpiry: ProposalsShow.reload_page
      description: ProposalsShow.times.descriptions.ends_at
    ,
      $.countdown.regionalOptions[Airesis.i18n.locale]

    if ProposalsShow.voting
      endsVote = new Date(ProposalsShow.times.vote_ends_at * 1000)
      $('.end-vote').countdown $.extend
        until: endsVote
        significant: 3
        description: ProposalsShow.times.descriptions.vote_ends_at
      ,
        $.countdown.regionalOptions[Airesis.i18n.locale]
  initVotePeriodSelect: ->
    $('#proposal_vote_period_id').select2
      minimumResultsForSearch: -1,
      templateResult: formatPeriod,
      templateSelection: formatPeriod,
      escapeMarkup: (m)->
        m

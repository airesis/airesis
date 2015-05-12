window.ProposalsEdit =
  integrated_contributes: []
  safe_exit: false
  init: ->
    integrate_contributes = []
    safe_exit = false
    window.onbeforeunload = @.check_before_exit
    $(document).on 'keyup', '.solution_main h3 .tit1 .tit2 input', ->
      id_ = $(this).closest('.solution_main').attr('data-solution_id')
      $('.navigator li[data-solution_id=' + id_ + '] span.sol_title').html $(this).val()
      return
    $(document).on 'keyup', 'input.edit_label', ->
      id_ = $(this).closest('.section_container').attr('data-section_id')
      $('.navigator li[data-section_id=' + id_ + '] a.sec_title').text $(this).val()
      return
    $('#menu-left, #centerpanelextended').addClass('editing')
    $('#proposal_proposal_category_id').select2
      minimumResultsForSearch: -1
      formatResult: formatCategory
      formatSelection: formatCategory
      escapeMarkup: (m)->
        return m
    suggestion_right_ = $('.suggestion_right')
    fitRightMenu(suggestion_right_)
    suggestion_right_.bind 'mousewheel DOMMouseScroll', (e)->
      if (matchMedia(Foundation.media_queries['medium']).matches)
        Airesis.scrolllock(suggestion_right_,e)
    fetchContributes()
    $(document).on 'click', '[data-update-and-exit-proposal]', ->
      ProposalsEdit.updateProposal()
    $(document).on 'click', '[data-update-proposal]', ->
      ProposalsEdit.updateAndContinueProposal()
    $('.navigator').on 'click', 'li:has(ul)', (event) ->
      console.log 'compress solution'
      if this == event.target
        $(this).toggleClass 'expanded'
        $(this).children('ul').toggle()
        solution_ = $('.solution_main[data-solution_id=' + $(this).data('solution_id') + ']')
        ProposalsEdit.compressSolution solution_, !solution_.attr('data-compressed')
      false
    $('.navigator li:has(ul)').addClass 'collapsed expanded'
    $('#expandList').unbind('click').click ->
      $('.collapsed').addClass 'expanded'
      $('.collapsed').children('ul').show()
      ProposalsEdit.compressSolutions false
      return
    $('#collapseList').unbind('click').click ->
      $('.collapsed').removeClass 'expanded'
      $('.collapsed').children('ul').hide()
      ProposalsEdit.compressSolutions true
      return
    $(document).on 'click', '[data-close-edit-right-section]', =>
      @.hideContributes()
      false
    $(document).on 'click', '[data-integrate-contribute]', ->
      ProposalsEdit.integrate_contribute(this)
    $('.navigator').on('click', '.sec_nav .move_up', ->
      list_element = $(this).parent()
      section_id = list_element.data('section_id')
      to_move = $('.section_container[data-section_id=' + section_id + ']')
      to_exchange = to_move.prevAll('.section_container').first()
      to_move.after to_exchange
#navigator update
      list_element_ex = list_element.prev()
      list_element.after list_element_ex
      ProposalsEdit.update_sequences $('.sections_column')
      return
      ).on('click', '.sec_nav .move_down', ->
        list_element = $(this).parent()
        section_id = list_element.data('section_id')
        to_move = $('.section_container[data-section_id=' + section_id + ']')
        to_exchange = to_move.nextAll('.section_container').first()
        to_move.before to_exchange
        #navigator update
        list_element_ex = list_element.next()
        list_element.before list_element_ex
        ProposalsEdit.update_sequences $('.sections_column')
        return
      ).on('click', '.sec_nav .remove', ->
        list_element = $(this).parent()
        section_id = list_element.data('section_id')
        to_remove = $('.section_container[data-section_id=' + section_id + ']')
        to_remove.find($('.remove_button a')).click()
        ProposalsEdit.update_sequences $('.sections_column')
        return
      ).on('click', '.sol_sec_nav .move_up', ->
        list_element = $(this).parent()
        solution_id = list_element.parent().parent().data('solution_id')
        section_id = list_element.data('section_id')
        to_move = $('.solutions_column[data-solution_id=' + solution_id + '] .section_container[data-section_id=' + section_id + ']')
        to_exchange = to_move.prevAll('.section_container').first()
        to_move.after to_exchange
        #navigator update
        list_element_ex = list_element.prev()
        list_element.after list_element_ex
        ProposalsEdit.update_sequences $('.solutions_column[data-solution_id=' + solution_id + ']')
        return
      ).on('click', '.sol_sec_nav .move_down', ->
        list_element = $(this).parent()
        solution_id = list_element.parent().parent().data('solution_id')
        section_id = $(this).parent().data('section_id')
        to_move = $('.solutions_column[data-solution_id=' + solution_id + '] .section_container[data-section_id=' + section_id + ']')
        to_exchange = to_move.nextAll('.section_container').first()
        to_move.before to_exchange
        #navigator update
        list_element_ex = list_element.next()
        list_element.before list_element_ex
        ProposalsEdit.update_sequences $('.solutions_column[data-solution_id=' + solution_id + ']')
        return
      ).on('click', '.sol_sec_nav .remove', ->
        list_element = $(this).parent()
        solution_id = list_element.parent().parent().data('solution_id')
        section_id = $(this).parent().data('section_id')
        to_remove = $('.solutions_column[data-solution_id=' + solution_id + '] .section_container[data-section_id=' + section_id + ']')
        to_remove.find($('.remove_button a')).click()
        ProposalsEdit.update_sequences $('.solutions_column[data-solution_id=' + solution_id + ']')
        return
      ).on('click', '.sol_nav .sol.move_up', ->
        list_element = $(this).parent()
        solution_id = list_element.data('solution_id')
        to_move = $('.solution_main[data-solution_id=' + solution_id + ']')
        to_exchange = to_move.prevAll('.solution_main').first()
        to_move.after to_exchange
        #navigator update
        list_element_ex = list_element.prev()
        list_element.after list_element_ex
        ProposalsEdit.update_solution_sequences()
        #todo update_sequences($('.solutions_column[data-solution_id='+solution_id+']'));
        return
      ).on('click', '.sol_nav .sol.move_down', ->
        list_element = $(this).parent()
        solution_id = list_element.data('solution_id')
        to_move = $('.solution_main[data-solution_id=' + solution_id + ']')
        to_exchange = to_move.nextAll('.solution_main').first()
        to_move.before to_exchange
        #navigator update
        list_element_ex = list_element.next()
        list_element.before list_element_ex
        ProposalsEdit.update_solution_sequences()
        #todo update_sequences($('.solutions_column[data-solution_id='+solution_id+']'));
        return
      ).on 'click', '.sol_nav .sol.remove', ->
        list_element = $(this).parent()
        solution_id = list_element.data('solution_id')
        to_remove = $('.solution_main[data-solution_id=' + solution_id + ']')
        #execute action clicking old button, now hidden
        to_remove.find($('.remove_sol_button a')).click()
        list_element.remove()
        ProposalsEdit.update_solution_sequences()
        #todo update_sequences($('.solutions_column[data-solution_id='+solution_id+']'));
        return
  integrate_contribute: (el) ->
    id = $(el).data('integrate-contribute')
    comment_ = $('#comment' + id)
    inside_ = comment_.find('.proposal_comment')
    if $(el).is(':checked')
      ProposalsEdit.integrated_contributes.push id
      comment_.fadeTo 400, 0.3
      inside_.attr 'data-height', inside_.outerHeight()
      inside_.css 'overflow', 'hidden'
      inside_.animate { height: '52px' }, 400
      comment_.find('[id^=reply]').each ->
        $(this).attr 'data-height', $(this).outerHeight()
        $(this).css 'overflow', 'hidden'
        $(this).animate { height: '0px' }, 400
        return
    else
      ProposalsEdit.integrated_contributes.splice ProposalsEdit.integrated_contributes.indexOf(id), 1
      comment_.fadeTo 400, 1
      inside_.animate { height: inside_.attr('data-height') }, 400, 'swing', ->
        inside_.css 'overflow', 'auto', ->
        return
      comment_.find('[id^=reply]').each ->
        $(this).animate { height: $(this).attr('data-height') }, 400, 'swing', ->
          $(this).css 'overflow', 'auto', ->
          return
        return
    $('#proposal_integrated_contributes_ids_list').val ProposalsEdit.integrated_contributes
    return
  updateProposal: ->
    if ($('.update2').attr('disabled') != 'disabled')
      $("form input:submit[data-type='save']").click()
    false
  updateAndContinueProposal: ->
    if $('.update3').attr('disabled') != 'disabled'
      $('form input:submit[data-type=\'continue\']').click()
    false
  scrollToSection: (el)->
    scrollToElement $('.section_container[data-section_id=' + $(el).parent().parent().attr('data-section_id') + ']')
    false
  hideContributes: ->
    right_ = $('.suggestion_right')
    if right_.hasClass('contributes_shown')
      right_.removeClass 'contributes_shown'
      right_.hide()
      $('#centerpanelextended').removeClass 'contributes_shown'
      $('#menu-left').removeClass 'contributes_shown'
    else
      right_.addClass 'contributes_shown'
      right_.show()
      $('#centerpanelextended').addClass 'contributes_shown'
      $('#menu-left').addClass 'contributes_shown'
    contributesButton = $('.contributes:visible')
    switchText contributesButton
    false
  compressSolution: (element, compress) ->
    toggleMinHeight = 100
    duration = 500
    easing = 'swing'
    compress_ = element
    curH = compress_.height()
    if compress_.is(':animated')
      return false
    else if compress_.attr('data-compressed') == 'false' and compress
      compress_.attr 'data-compressed', true
      compress_.attr 'data-height', compress_.height()
      $('.sol_content', compress_).hide()
      compress_.animate { 'height': toggleMinHeight }, duration, easing, ->
    else if compress_.attr('data-compressed') == 'true' and !compress
      compress_.attr 'data-compressed', false
      compress_.animate { 'height': compress_.attr('data-height') }, duration, easing, ->
      $('.sol_content', compress_).show()
    return
  compressSolutions: (compress) ->
    $('.solution_main').each ->
      ProposalsEdit.compressSolution $(this), compress
      return
    compressButton = $('.compress')
    false
  check_before_exit: ->
    if ProposalsEdit.safe_exit
      null
    else
      'Tutte le modifiche alla proposta andranno perse.'
  getCleanContent: (editor_id) ->
    editor = CKEDITOR.instances[editor_id]
    editor.plugins.lite.findPlugin(editor)._tracker.getCleanContent()
  update_sequences: (container) ->
    i = 0
    container.find('.section_container').each (el) ->
      id = $(this).find('textarea').attr('id')
      seq_id = id.replace(/paragraphs_attributes.*/, 'seq')
      $('#' + seq_id).val i++
      return
    return
  update_solution_sequences: ->
    i = 0
    $('.solution_main').each (el) ->
      id = $(this).data('solution_id')
      seq_id = 'proposal_solutions_attributes_' + id + '_seq'
      $('#' + seq_id).val i++
      return
    return
  geocode_panel: ->
    return

window.ProposalsUpdate = window.ProposalsEdit

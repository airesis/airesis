window.ProposalsEdit =
  integrated_contributes: []
  safe_exit: false
  currentPage: 0
  currentView: 3
  contributes: []
  checkActive: false
  ckedstoogle_: {}
  init: ->
    ProposalsEdit.integrated_contributes = []
    safe_exit = false
    window.onbeforeunload = @.check_before_exit
    $(document).on 'keyup', '.solution_main h3 .tit1 .tit2 input', ->
      id_ = $(this).closest('.solution_main').attr('data-solution_id')
      title = if !!$(this).val() then $(this).val() else '&nbsp;'
      $('.navigator li[data-solution_id=' + id_ + '] span.sol_title').html title
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

    start_field = $('#proposal_vote_starts_at')
    end_field = $('#proposal_vote_ends_at')
    start_field.fdatetimepicker($.fn.fdatetimepicker.dates[Airesis.i18n.locale]).on 'hide', (event) ->
      eventStartTime_ = event.date
      end_field.fdatetimepicker 'setStartDate', eventStartTime_
      end_field.fdatetimepicker 'setDate', addMinutes(eventStartTime_, 2880)
      return
    end_field.fdatetimepicker $.fn.fdatetimepicker.dates[Airesis.i18n.locale]
    start_field.fdatetimepicker 'setStartDate', ProposalsEdit.voteStartsAt
    end_field.fdatetimepicker 'setStartDate', ProposalsEdit.voteEndsAt
    input = $('#proposal_interest_borders_tkn')
    input.tokenInput '/interest_borders.json',
      crossDomain: false
      prePopulate: input.data('pre')
      hintText: Airesis.i18n.interestBorders.hintText
      noResultsText: Airesis.i18n.interestBorders.noResultsText
      searchingText: Airesis.i18n.interestBorders.searchingText
      preventDuplicates: true

    input = $('#proposal_tags_list')
    if input
      input.tokenInput '/tags.json',
        theme: 'facebook'
        crossDomain: false
        prePopulate: ProposalsEdit.tags
        allowFreeTagging: true
        minChars: 3
        hintText: Airesis.i18n.tags.hintText
        searchingText: Airesis.i18n.tags.searchingText
        preventDuplicates: true
        allowTabOut: true
        tokenValue: 'name'

    $('[data-add-section]').on 'click', =>
      @addSection()
      return false

    $(document).on 'click', '[data-add-solution-section]', =>
      solutionId = `$(this)`.data('solution_id')
      @addSolutionSection(solutionId)
      return false

    $('[data-add-solution]').on 'click', =>
      @addSolution()
      return false

    $(document).on 'click', '[data-remove-solution]', =>
      solutionId = `$(this)`.data('solution_id')
      @navigator.removeSolution(solutionId)
      return false
    #editors
    $(Airesis.SectionContainer.selector).each ->
      container = new Airesis.SectionContainer(@)
      container.initCkEditor()


    for name of CKEDITOR.instances
      ProposalsEdit.ckedstoogle_[name] =
        first: true
      editor = CKEDITOR.instances[name]
      ProposalsEdit.addEditorEvents editor

    $('[data-clean-fields=true]').on 'click', =>
      @updateSolutionSequences()
      @fillCleanFields()

    suggestion_right_ = $('.suggestion_right')
    fitRightMenu(suggestion_right_)
    suggestion_right_.bind 'mousewheel DOMMouseScroll', (e)->
      if (matchMedia(Foundation.media_queries['medium']).matches)
        Airesis.scrollLock(suggestion_right_, e)

    #contributes
    @fetchContributes()

    $(document).on 'click', '[data-integrate-contribute]', ->
      ProposalsEdit.integrate_contribute(this)
    $(document).on 'click', '[data-close-edit-right-section]', =>
      @.hideContributes()
      false
    # left panel buttons
    $(document).on 'click', '[data-update-and-exit-proposal]', ->
      ProposalsEdit.updateProposal()
    $(document).on 'click', '[data-update-proposal]', ->
      ProposalsEdit.updateAndContinueProposal()

    #navigator
    @navigator = new Airesis.ProposalNavigator
  addEditorEvents: (editor_) ->
    editor_.on 'lite:init', (event) ->
      ProposalsEdit.ckedstoogle_[event.editor.name]['first'] = false
      lite = event.data.lite
      ProposalsEdit.ckedstoogle_[event.editor.name]['editor'] = lite
      lite.toggleShow ProposalsEdit.ckedstoogle_[event.editor.name]['state']
      lite.setUserInfo
        id: Airesis.id
        name: Airesis.fullName
      return
    editor_.on 'lite:showHide', (event) ->
      if !ProposalsEdit.ckedstoogle_[event.editor.name]['first']
        ProposalsEdit.ckedstoogle_[event.editor.name]['state'] = event.data.show
      return
    return
  addEditor: (id) ->
    CKEDITOR.remove(CKEDITOR.instances[id])
    editor_ = CKEDITOR.replace(id,
      'toolbar': 'proposal'
      'language': Airesis.i18n.locale
      'customConfig': Airesis.assets.ckeditor.config_lite)
    ProposalsEdit.ckedstoogle_[id] =
      first: true
    ProposalsEdit.addEditorEvents editor_
    return
  fillCleanFields: ->
    integrated_ = $('#proposal_integrated_contributes_ids_list').val()
    if ProposalsEdit.contributesCount > 0
      if integrated_ == ''
        if !confirm(Airesis.i18n.proposals.edit.updateConfirm)
          return false
    try
      id = undefined
      for id of CKEDITOR.instances
        `id = id`
        editor = CKEDITOR.instances[id]
        textarea_ = $('#' + id)
        clean = ProposalsEdit.getCleanContent(id)
        name_ = textarea_.attr('name').replace('_dirty', '').replace(/\[/g, '\\[').replace(/\]/g, '\\]')
        target = $('[name=' + name_ + ']')
        target.val clean
    catch err
      console.error err
      console.error 'error in parsing ' + name
      return false
    $('.update2').attr 'disabled', 'disabled'
    ProposalsEdit.safe_exit = true
    true
  integrate_contribute: (el) ->
    id = $(el).data('integrate-contribute')
    comment_ = $('#comment' + id)
    inside_ = comment_.find('.proposal_comment')
    if $(el).is(':checked')
      ProposalsEdit.integrated_contributes.push id
      comment_.fadeTo 400, 0.3
      inside_.attr 'data-height', inside_.outerHeight()
      inside_.css 'overflow', 'hidden'
      inside_.animate {height: '52px'}, 400
      comment_.find('[id^=reply]').each ->
        $(this).attr 'data-height', $(this).outerHeight()
        $(this).css 'overflow', 'hidden'
        $(this).animate {height: '0px'}, 400
        return
    else
      ProposalsEdit.integrated_contributes.splice ProposalsEdit.integrated_contributes.indexOf(id), 1
      comment_.fadeTo 400, 1
      inside_.animate {height: inside_.attr('data-height')}, 400, 'swing', ->
        inside_.css 'overflow', 'auto', ->
        return
      comment_.find('[id^=reply]').each ->
        $(this).animate {height: $(this).attr('data-height')}, 400, 'swing', ->
          $(this).css 'overflow', 'auto', ->
          return
        return
    $('#proposal_integrated_contributes_ids_list').val ProposalsEdit.integrated_contributes
    return
  fetchContributes: ->
    ProposalsEdit.currentPage++
    $.ajax
      url: ProposalsEdit.contributesUrl
      data:
        disable_limit: true
        page: ProposalsEdit.currentPage
        view: ProposalsEdit.currentView
        contributes: ProposalsEdit.contributes
        all: true
      type: 'get'
      dataType: 'script'
      complete: ->
        $('#loading_contributes').hide()
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
  toggleSolutions: (compress) ->
    $('.solution_main').each ->
      solution = new Airesis.SolutionContainer($(@))
      solution.toggle(compress)
    false
  check_before_exit: ->
    unless ProposalsEdit.safe_exit
      'Tutte le modifiche alla proposta andranno perse.'
  getCleanContent: (editor_id) ->
    editor = CKEDITOR.instances[editor_id]
    editor.plugins.lite.findPlugin(editor)._tracker.getCleanContent()
  calculateDataId: (i, j)->
    ((i + 1) * 100) + j
  updateSequences: ->
    $('.sections_column, .solutions_column').each ->
      i = 0
      $(this).find(Airesis.SectionContainer.selector).each (el) ->
        section = new Airesis.SectionContainer($(this))
        section.setSeq(i++)
  updateSolutionSequences: ->
    i = 0
    $('.solution_main').each ->
      solution = new Airesis.SolutionContainer($(@))
      solution.setSeq(i++)
  addSection: ->
    title = Airesis.i18n.proposals.edit.paragraph + ' ' + (ProposalsEdit.sectionsCount + 1)
    sectionId = ProposalsEdit.sectionsCount
    section = $(Mustache.to_html($('#section_template').html(), section:
      id: sectionId
      seq: sectionId + 1
      removeSection: Airesis.i18n.proposals.edit.removeSection
      title: title
      paragraphId: ''
      content: ''
      contentDirty: ''
      persisted: false))
    $('.sections_column').append section
    section.fadeIn()
    new (Airesis.SectionContainer)(section).initCkEditor()
    @navigator.addSectionNavigator(sectionId, title)
    ProposalsEdit.sectionsCount += 1
    return
  addSolutionSection: (solutionId)->
    sectionId = ProposalsEdit.numSolutionSections[solutionId]
    title = Airesis.i18n.proposals.edit.paragraph + ' ' + (sectionId + 1)
    dataId = ProposalsEdit.calculateDataId(parseInt(solutionId), sectionId)
    solutionSection = $(Mustache.to_html($('#solution_section_template').html(),
      section:
        idx: sectionId
        data_id: dataId
        seq: sectionId + 1
        removeSection: Airesis.i18n.proposals.edit.removeSection
        title: title
        paragraphId: ''
        content: ''
        contentDirty: ''
        persisted: false
      solution:
        id: solutionId))
    $(".solutions_column[data-solution_id=#{solutionId}]").append(solutionSection)
    $(".solution_main[data-solution_id=#{solutionId}]").css('height', '')
    solutionSection.fadeIn()
    new Airesis.SectionContainer(solutionSection).initCkEditor()
    @navigator.addSolutionSectionNavigator(solutionId, dataId, title)
    ProposalsEdit.numSolutionSections[solutionId] += 1
  addSolution: ->
    jQuery.each ProposalsEdit.mustacheSections, (idx, section) ->
      section['solution']['id'] = ProposalsEdit.solutionsCount
      section['section']['data_id'] = ProposalsEdit.calculateDataId(ProposalsEdit.solutionsCount, section['section']['idx'])
    options = solution:
      id: ProposalsEdit.solutionsCount
      seq: ProposalsEdit.fakeSolutionsCount
      persisted: true
      title_placeholder: Airesis.i18n.proposals.edit.titlePlaceholder
      solution_title: Airesis.i18n.proposals.edit.solutionTitle
      title: ''
      removeSolution: Airesis.i18n.proposals.edit.removeSolution
      addParagraph: Airesis.i18n.proposals.edit.addParagraph
      sections: ProposalsEdit.mustacheSections
    solution = $(Mustache.to_html($('#solution_template').html(),
      options,
      'proposals/_solution_section': $('#solution_section_template').html()))
    solution.find('.title_placeholder .num').html ProposalsEdit.fakeSolutionsCount + 1
    $("[data-hook='new-solution']").before solution
    solution.fadeIn()

    solution.find(Airesis.SectionContainer.selector).each (idx, section)->
      new Airesis.SectionContainer(section).initCkEditor()
    @navigator.addSolutionNavigator(ProposalsEdit.solutionsCount)

    ProposalsEdit.numSolutionSections[ProposalsEdit.solutionsCount] = solution.find('.section_container').length
    ProposalsEdit.solutionsCount++
    ProposalsEdit.fakeSolutionsCount++
  geocode_panel: ->
    return

window.ProposalsUpdate = window.ProposalsEdit

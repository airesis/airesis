class @ProposalSectionEditor
  constructor: (@sectionId)->
    @integrator = new ProposalCommentsIntegrator();
    @showSection = @getShowSection()
    @editSection = @getEditSection()
    @textarea = @editSection.find('textarea')
    @textareaId = @textarea.attr('id')
    @cleanarea = @editSection.find('[data-clean-text-area]')
    @contributesNum = $("[data-contribute-button][data-section_id=#{@sectionId}]").data('contributes_num')
    @form = @editSection.find('form')
  showEditSection: =>
    ProposalSectionEditor.editParagraphButtons().hide()
    @initCkEditor(@textareaId)
    @showSection.fadeOut 'slow', =>
      @editSection.fadeIn('slow')
  updateSection: =>
    @updateContent()
    console.log "this section has #{@contributesNum} contributes"
    if @contributesNum > 0
      @showIntegrateContributesPanel()
    else
      @submit()
  submit: ->
    @hideIntegratedContributes()
    @form.submit()
    @hideEditSection()
  hideIntegratedContributes: ->
    for id in @integrator.integrated_contributes
      contribute = new ProposalContribute(id, @sectionId).integrate()
  hideEditSection: ->
    @editSection.fadeOut 'slow', =>
      @showSection.fadeIn()
      ProposalSectionEditor.editParagraphButtons().show()
  updateContent: =>
    cleancontent = @getCleanContent()
    dirtycontent = @getDirtyContent()
    @cleanarea.val cleancontent
    @showSection.html(cleancontent)
    @textarea.val(dirtycontent)
  getShowSection: ->
    $("[data-section_id=#{@sectionId}]").find('[data-show-section]')
  getEditSection: ->
    $("[data-section_id=#{@sectionId}]").find('[data-edit-section]')
  showIntegrateContributesPanel: =>
    $.ajax
      url: ProposalsShow.integrateContributesUrl
      data:
        disable_limit: true
        all: true
        section_id: @sectionId
      type: 'get'
      dataType: 'script'
      success: =>
        container_ = $('#integrate_contributes_container')
        $(document).unbind 'closed.fndtn.reveal'
        $(document).on 'closed.fndtn.reveal', container_, =>
          container_.remove()
          @submit()
  initCkEditor: (id)->
    ckeditor = CKEDITOR.instances[id]
    unless ckeditor
      editor = CKEDITOR.replace(id,
        'toolbar': 'simple_proposal'
        'language': Airesis.i18n.locale
        'customConfig': Airesis.assets.ckeditor.config_lite)
      editor.on 'lite:init', (event) ->
        lite = editor.plugins.lite.findPlugin(editor)
        lite.toggleShow()
        lite.setUserInfo
          id: Airesis.id
          name: Airesis.fullName
        return
  getCleanContent: ->
    editor = CKEDITOR.instances[@textareaId]
    editor.plugins.lite.findPlugin(editor)._tracker.getCleanContent()
  getDirtyContent: ->
    editor = CKEDITOR.instances[@textareaId]
    editor.getData()
  @editParagraphButtons: ->
    $('[data-edit-paragraph]')
  @showParagraphButtons: ->
    $('[data-show-paragraph]')

class @ProposalInlineEditor
  constructor: ->
    ProposalSectionEditor.editParagraphButtons().on 'click', (event)=>
      section_id = $(event.target).parent().data('edit-paragraph')
      sectionEditor = new ProposalSectionEditor(section_id)
      sectionEditor.showEditSection()
      return false
    ProposalSectionEditor.showParagraphButtons().on 'click', (event)=>
      section_id = $(event.target).parents('[data-edit-section]').data('edit-section')
      sectionEditor = new ProposalSectionEditor(section_id)
      sectionEditor.updateSection()
      return false

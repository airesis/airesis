class @ProposalInlineEditor
  constructor: ->
    edit_paragraph_button = $('[data-edit-paragraph]')
    show_paragraph_button = $('[data-show-paragraph]')
    edit_paragraph_button.on 'click', (event)=>
      section_id = $(event.target).data('edit-paragraph')
      show_section = @getShowSection(section_id)
      edit_section = @getEditSection(section_id)
      edit_paragraph_button.hide()
      textarea = edit_section.find('textarea')
      ckeditor_id = textarea.attr('id')
      @initCkEditor(ckeditor_id)
      show_section.fadeOut 'slow', =>
        edit_section.fadeIn('slow')
      return false
    show_paragraph_button.on 'click', (event)=>
      section_id = $(event.target).data('show-paragraph')
      show_section = @getShowSection(section_id)
      edit_section = @getEditSection(section_id)
      textarea = edit_section.find('textarea')
      ckeditor_id = textarea.attr('id')
      show_section.html(CKEDITOR.instances[ckeditor_id].getData())
      edit_section.fadeOut 'slow', ->
        show_section.fadeIn()
        edit_paragraph_button.show()
  getShowSection: (id)->
    $("[data-section_id=#{id}]").find('[data-show-section]')
  getEditSection: (id)->
    $("[data-section_id=#{id}]").find('[data-edit-section]')
  initCkEditor: (id)->
    ckeditor = CKEDITOR.instances[id]
    unless ckeditor
      CKEDITOR.replace(id,
        'toolbar': 'simple_proposal'
        'language': Airesis.i18n.locale)

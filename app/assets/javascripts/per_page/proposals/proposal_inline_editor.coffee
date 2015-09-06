class @ProposalInlineEditor
  constructor: ->
    edit_paragraph_button = $('[data-edit-paragraph]')
    show_paragraph_button = $('[data-show-paragraph]')
    edit_paragraph_button.on 'click', (event)=>
      section_id = $(event.target).parent().data('edit-paragraph')
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
      section_id = $(event.target).parents('[data-edit-section]').data('edit-section')
      show_section = @getShowSection(section_id)
      edit_section = @getEditSection(section_id)
      textarea = edit_section.find('textarea')
      cleanarea = edit_section.find('[data-clean-text-area]')
      form = edit_section.find('form')
      ckeditor_id = textarea.attr('id')
      cleancontent = @getCleanContent(ckeditor_id)
      dirtycontent = @getDirtyContent(ckeditor_id)
      cleanarea.val cleancontent
      show_section.html(cleancontent)
      textarea.val(dirtycontent)
      form.submit()
      edit_section.fadeOut 'slow', ->
        show_section.fadeIn()
        edit_paragraph_button.show()
      return false
  getShowSection: (id)->
    $("[data-section_id=#{id}]").find('[data-show-section]')
  getEditSection: (id)->
    $("[data-section_id=#{id}]").find('[data-edit-section]')
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
  getCleanContent: (editor_id) ->
    editor = CKEDITOR.instances[editor_id]
    editor.plugins.lite.findPlugin(editor)._tracker.getCleanContent()
  getDirtyContent: (editor_id) ->
    editor = CKEDITOR.instances[editor_id]
    editor.getData()

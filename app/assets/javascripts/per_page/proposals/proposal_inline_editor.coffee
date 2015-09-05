class @ProposalInlineEditor
  constructor: ->
    edit_paragraph_button = $('[data-edit-paragraph]')
    show_paragraph_button = $('[data-show-paragraph]')
    edit_paragraph_button.on 'click', ->
      section_id = $(@).data('edit-paragraph')
      show_section = $("[data-section_id=#{section_id}]").find('[data-show-section]')
      edit_section = $("[data-section_id=#{section_id}]").find('[data-edit-section]')
      edit_paragraph_button.hide()
      show_section.fadeOut 'slow', ->
        edit_section.fadeIn()
      return false
    show_paragraph_button.on 'click', ->
      section_id = $(@).data('show-paragraph')
      show_section = $("[data-section_id=#{section_id}]").find('[data-show-section]')
      edit_section = $("[data-section_id=#{section_id}]").find('[data-edit-section]')
      show_section.html(edit_section.find('textarea').val())
      edit_section.fadeOut 'slow', ->
        show_section.fadeIn()
        edit_paragraph_button.show()


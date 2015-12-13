window.PostsEdit =
  init: ->
    editor_id = 'frm_post_text'
    text_editor = CKEDITOR.instances[editor_id]
    text_editor.on 'change', ->
      text_editor.updateElement()
      $(editor_id).closest('form').formValidation 'revalidateField', 'frm_post[text]'

window.PostsUpdate = window.PostsEdit

window.PostsEdit =
  init: ->
    text_editor = CKEDITOR.instances['frm_post_text']
    text_editor.on 'change', ->
      text_editor.updateElement()
      $('form').formValidation 'revalidateField', 'frm_post[text]'

window.PostsUpdate = window.PostsEdit

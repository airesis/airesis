window.PostsNew =
  init: ->
    text_editor = CKEDITOR.instances['frm_post_text']
    text_editor.on 'change', ->
      text_editor.updateElement()
      console.log 'init'
      $('form').formValidation 'revalidateField', 'frm_post[text]'

window.PostsCreate = window.PostsNew

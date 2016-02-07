window.TopicsNew =
  init: ->
    form = $('#new_frm_topic')
    text_editor = CKEDITOR.instances['frm_topic_posts_attributes_0_text']
    text_editor.on 'change', ->
      text_editor.updateElement()
      form.formValidation 'revalidateField', 'frm_topic[posts_attributes][0][text]'

window.TopicsCreate = window.TopicsNew

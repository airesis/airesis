window.ModsShow =
  init: ->
    $("#frm_user_id").select2
      containerCssClass: 'user_auto'
      ajax:
        url: ModsShow.autocompleteUrl
        data: (term, page)->
          {'term': term}
        results: (data, page)->
          {results: data}
      formatResult: ModsShow.format,
      formatSelection: ModsShow.format
  format: (state)->
    if !state.id
      return state.text
    state.image_path + state.identifier


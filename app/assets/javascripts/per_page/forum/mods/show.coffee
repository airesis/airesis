window.ModsShow =
  init: ->
    $("#frm_user_id").select2
      ajax:
        url: ModsShow.autocompleteUrl
        dataType: 'json'
        data: (params)->
          return {
            term: params.term,
            l: Airesis.i18n.locale,
            pp: 'disable'
          }
        processResults: (data, page)->
          return {
            results: data
          }
        cache: true
      templateResult: ModsShow.format,
      templateSelection: ModsShow.format
  format: (state)->
    if !state.id
      return state.text
    $('<span>' + state.image_path + state.identifier + '</span>')

window.MembersAdd = window.ModsShow

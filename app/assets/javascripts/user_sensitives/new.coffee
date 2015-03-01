window.UserSensitivesNew =
  user_format: (state)->
    if (!state.id)
      return state.text
    return state.image_path + state.identifier
  init: ->
    user_sensitive_id_field = $("#user_sensitive_user_id")
    user_sensitive_name_field = $("#user_sensitive_name")
    user_sensitive_surname_field = $("#user_sensitive_surname")
    user_sensitive_birthdate_field = $("#user_sensitive_birth_date")
    user_sensitive_id_field.select2({
      containerCssClass: "user_auto",
      ajax: {
        url: user_sensitive_id_field.data('fetch-url'),
        data: (term, page)->
          return "term": term
        ,
        results: (data, page)->
          return results: data
      },
      formatResult: @user_format,
      formatSelection: @user_format
    })
    .on('change', (e)->
      el = e.added
      user_sensitive_name_field.val(el.name)
      user_sensitive_surname_field.val(el.surname)
    )
    user_sensitive_birthdate_field.datepicker
      changeMonth: true,
      changeYear: true,
      defaultDate: "-18y",
      yearRange: "-100:+0",
      minDate: "-100y",
      maxDate: "+0d"


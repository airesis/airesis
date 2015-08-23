class @AiresisFormValidation
  constructor: (form)->
    translations = {}
    translations[Airesis.i18n.locale] = Airesis.i18n.validationMessages
    FormValidation.I18n = $.extend true, FormValidation.I18n || {},
      translations
    form.formValidation
      locale: Airesis.i18n.locale
      framework: 'foundation'
      icon:
        valid: 'fa fa-check'
        invalid: 'fa fa-times'
        validating: 'fa fa-refresh'
      trigger: 'blur'
      row:
        selector: '.inputs'
      fields:
        'proposal[title]':
          validators:
            remote:
              message: Airesis.i18n.validationMessages.alreadyTaken.default
              url: '/validators/uniqueness/proposal'
              data: (validator, $field, value)->
                {
                'proposal[title]': value
                'proposal[id]': $field.data('fv-remote-id')
                }
              type: 'GET'
              delay: 1000
        'user[email]':
          validators:
            remote:
              message: Airesis.i18n.validationMessages.alreadyTaken.default
              url: '/validators/uniqueness/user'
              type: 'GET'
              delay: 1000
        'group[name]':
          validators:
            remote:
              message: Airesis.i18n.validationMessages.alreadyTaken.default
              url: '/validators/uniqueness/group'
              data: (validator, $field, value)->
                {
                  'group[name]': value
                  'group[id]': $field.data('fv-remote-id')
                }
              type: 'GET'
              delay: 1000
        'proposal[proposal_category_id]':
          excluded: false
        'proposal[sections_attributes][0][seq]':
          excluded: false
          validators:
            callback:
              message: Airesis.i18n.validationMessages.notEmpty.default
              callback: (value, validator, $field)->
                if value is ''
                  return false
                else
                  div  = $('<div/>').html(value).get(0)
                  text = div.textContent || div.innerText
                  return text.length > 0

        'group[interest_border_tkn]':
          excluded: false
        'group[description]':
          excluded: false
          validators:
            callback:
              message: Airesis.i18n.validationMessages.notEmpty.default
              callback: (value, validator, $field)->
                if value is ''
                  return false
                else
                  div  = $('<div/>').html(value).get(0)
                  text = div.textContent || div.innerText
                  return text.length > 0

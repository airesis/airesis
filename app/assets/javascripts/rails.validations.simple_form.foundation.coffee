ClientSideValidations.formBuilders['SimpleForm::FormBuilder'].wrappers.foundation =
  add: (element, settings, message) ->
    errorElement = element.parent().find "#{settings.error_tag}.#{settings.error_class}"
    if not errorElement[0]?
      wrapper_tag_element = element.closest(settings.wrapper_tag)
      errorElement = $("<#{settings.error_tag}/>", {class: settings.error_class, text: message, style: 'display:block'})
      errorElement.hide()
      wrapper_tag_element.append(errorElement)
    wrapper_class_element = element.closest(".#{settings.wrapper_class}");
    wrapper_class_element.addClass(settings.wrapper_error_class)
    errorElement.text(message)
    errorElement.slideDown()
  remove: (element, settings) ->
    wrapper_class_element = element.closest(".#{settings.wrapper_class}.#{settings.wrapper_error_class}")
    wrapper_tag_element = element.closest(settings.wrapper_tag)
    wrapper_class_element.removeClass(settings.wrapper_error_class)
    errorElement = wrapper_tag_element.find("#{settings.error_tag}.#{settings.error_class}")
    errorElement.remove()

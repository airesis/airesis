class DatetimepickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    @input_html_options[:data] ||= {}
    @input_html_options[:data][:datetimepicker] = ''
    super
  end

  def input_type
    :string
  end
end

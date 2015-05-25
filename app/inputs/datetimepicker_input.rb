class DatetimepickerInput < SimpleForm::Inputs::StringInput
  def input
    @input_html_options[:data] ||= {}
    @input_html_options[:data][:datetimepicker] = ''
    super
  end

  def input_type
    :string
  end
end

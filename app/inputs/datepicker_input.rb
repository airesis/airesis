class DatepickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    @input_html_options[:data] ||= {}
    @input_html_options[:data][:start_view] ||= 4
    @input_html_options[:data][:min_view] ||= 2
    @input_html_options[:data][:datepicker] = ''
    super
  end

  def input_type
    :string
  end
end

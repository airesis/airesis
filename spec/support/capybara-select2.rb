module Capybara
  module Select2
    def select2(value, options = {})
      unless options.is_a?(Hash) && %i[from xpath].any? { |k| options.key? k }
        raise "Must pass a hash containing 'from' or 'xpath'"
      end

      if options.key? :xpath
        select2_container = first(:xpath, options[:xpath])
      else
        select_name = options[:from]
        select2_container = first('label', text: select_name).find(:xpath, '..').find('.select2-container')
      end

      select2_container.find('.select2-choice').click

      [value].flatten.each do |value|
        find(:xpath, '//body').find('.select2-drop li', text: value).click
      end
    end

    def select2ajax(css_selector, value = nil)
      page.execute_script(%|$('#{css_selector}').select2("open");|)
      page.execute_script(%|$('.select2-search__field').val('#{value[0, 2]}').trigger('keyup');|) if value
      page.execute_script %|
                            window.setTimeout( function() {
                              $('.select2-results__option--highlighted').trigger('mouseup');
                            }, 1000);|
      sleep 1.5
    end
  end
end

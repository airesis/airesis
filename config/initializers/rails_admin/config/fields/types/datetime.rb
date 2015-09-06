require 'rails_admin/config/fields/base'
require 'rails_admin/i18n_support'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          class << self
            def normalize(date_string, format)
              unless I18n.locale == 'en'
                format.to_s.scan(/%[AaBbp]/) do |match|
                  case match
                    when '%A'
                      english = I18n.t('date.day_names')
                      day_names.each_with_index { |d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
                    when '%a'
                      english = I18n.t('date.abbr_day_names')
                      abbr_day_names.each_with_index { |d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
                    when '%B'
                      english = I18n.t('date.month_names')[1..-1]
                      month_names.each_with_index { |m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
                    when '%b'
                      english = I18n.t('date.abbr_month_names')[1..-1]
                      abbr_month_names.each_with_index { |m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
                    when '%p'
                      date_string = date_string.gsub(/#{I18n.t('date.time.am', default: "am")}/, 'am')
                      date_string = date_string.gsub(/#{I18n.t('date.time.pm', default: "pm")}/, 'pm')
                  end
                end
              end
              parse_date_string(date_string)
            end
          end

          def js_plugin_options
            options = {
              'datepicker' => {
                'dateFormat' => js_date_format,
                'dayNames' => self.class.day_names,
                'dayNamesShort' => self.class.abbr_day_names,
                'dayNamesMin' => self.class.abbr_day_names,
                'firstDay' => 1,
                'monthNames' => self.class.month_names,
                'monthNamesShort' => self.class.abbr_month_names,
                'value' => formatted_date_value,
              },
              'timepicker' => {
                'amPmText' => meridian_indicator? ? %w(Am Pm) : ['', ''],
                'hourText' => I18n.t('datetime.prompts.hour', default: I18n.t('datetime.prompts.hour')),
                'minuteText' => I18n.t('datetime.prompts.minute', default: I18n.t('datetime.prompts.minute')),
                'showPeriod' => meridian_indicator?,
                'value' => formatted_time_value,
              },
            }

            options.merge(self.class.js_plugin_options)
          end

          def localized_format(scope = [:time, :formats])
            format = date_format.to_sym
            I18n.t(format, scope: scope, default: [
                           I18n.t(format, scope: scope),
                           I18n.t(self.class.format, scope: scope),
                         ]).to_s
          end
        end
      end
    end
  end
end

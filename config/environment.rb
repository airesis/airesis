require_relative 'application'

Rails.application.initialize!

# patch to provide missing translations to rails using existing yml files
# I18n.available_locales.each do |locale|
#   puts "adding dynamically #{locale}"
#   I18n.backend.store_translations(locale, date: { abbr_day_names: I18n.t('calendar.dayNamesShort', locale: locale) })
#   I18n.backend.store_translations(locale, date: { abbr_month_names: [nil] + I18n.t('calendar.monthNamesShort', locale: locale) })
#   I18n.backend.store_translations(locale, date: { day_names: I18n.t('calendar.dayNames', locale: locale) })
#   I18n.backend.store_translations(locale, date: { month_names: [nil] + I18n.t('calendar.monthNames', locale: locale) })
# end

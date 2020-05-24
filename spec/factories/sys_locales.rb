FactoryBot.define do
  factory :sys_locale do
    initialize_with { SysLocale.find_or_initialize_by(key: key) }

    territory { create(:country) }
    key { 'it-IT' }
    host { 'airesis.it' }
    default { false }
    lang { nil }

    trait :default do
      key { 'en-EU' }
      host { 'localhost' }
      territory { create(:continent, :europe) }
      default { true }
    end
  end
end

FactoryBot.define do
  factory :sys_locale do
    territory { create(:country) }
    key { 'it-IT' }
    host { 'airesis.it' }
    default { false }
    lang { nil }
  end
end

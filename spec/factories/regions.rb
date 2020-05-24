FactoryBot.define do
  factory :region do
    initialize_with { Region.find_or_initialize_by(description: description) }

    association :country
    continent { country.continent }
    description { Faker::Lorem.word }

    trait :emilia_romagna do
      country { build(:country, :italy) }
      description { 'Emilia Romagna' }
    end
  end
end

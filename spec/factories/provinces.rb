FactoryBot.define do
  factory :province do
    initialize_with { Province.find_or_initialize_by(description: description) }
    region { build(:region) }
    country { region.country }
    continent { region.continent }
    description { Faker::Lorem.word }

    trait :bologna do
      region { build(:region, :emilia_romagna) }
      description { 'Emilia Romagna' }
    end
  end
end

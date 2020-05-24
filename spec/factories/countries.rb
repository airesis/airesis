FactoryBot.define do
  factory :country do
    initialize_with { Country.find_or_initialize_by(description: description) }

    association :continent
    sigla { Faker::Lorem.word }
    description { Faker::Lorem.word }

    trait :italy do
      continent { build(:continent, :europe) }
      sigla { 'IT' }
      description { 'Italy' }
    end
  end
end

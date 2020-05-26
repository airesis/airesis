FactoryBot.define do
  factory :continent do
    initialize_with { Continent.find_or_initialize_by(description: description) }

    description { Faker::Lorem.word }

    trait :europe do
      description { 'Europe' }
    end
  end
end

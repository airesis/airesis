FactoryBot.define do
  factory :municipality do
    initialize_with { Municipality.find_or_initialize_by(description: description) }

    association :province
    region { province.region }
    country { region.country }
    continent { country.continent }
    description { Faker::Lorem.word }

    trait :bologna do
      description { 'Bologna' }
      province { build(:province, :bologna) }
      region { province.region }
      country { province.country }
      continent { province.continent }
      population { 371_217 }
    end
  end
end

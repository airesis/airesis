FactoryBot.define do
  factory :tag do
    text { Faker::Color.color_name }
  end
end

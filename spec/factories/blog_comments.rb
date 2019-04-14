FactoryBot.define do
  factory :blog_comment do
    association :user
    association :blog_post
    body { Faker::Lorem.paragraph }
  end
end

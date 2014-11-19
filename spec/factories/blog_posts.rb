FactoryGirl.define do
  factory :blog_post do
    title { Faker::Company.name }
    body {Faker::Lorem.paragraph}
    status BlogPost::PUBLISHED
    association :user
    association :blog
  end
end

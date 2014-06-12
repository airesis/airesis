FactoryGirl.define do
  factory :blog_post do
    title { Faker::Company.name }
    body {Faker::Lorem.paragraph}
    status 'P'
    association :user
    association :blog
  end
end
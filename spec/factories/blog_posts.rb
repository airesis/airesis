FactoryGirl.define do
  factory :blog_post do
    title { Faker::Company.name }
    body { Faker::Lorem.paragraph }
    status BlogPost::PUBLISHED
    association :user
    association :blog
    factory :group_blog_post do
      groups { create_list(:group, 2) }
    end
  end
end

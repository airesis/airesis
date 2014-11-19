FactoryGirl.define do
  factory :post_publishing do
    association :group
    association :blog_post
  end
end

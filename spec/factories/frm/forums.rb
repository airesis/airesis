FactoryGirl.define do
  factory :frm_forum, class: Frm::Forum do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    association :group
    association :category, factory: :frm_category
    visible_outside true
  end
end

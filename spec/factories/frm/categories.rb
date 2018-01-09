FactoryGirl.define do
  factory :frm_category, class: Frm::Category do
    name { Faker::Company.name }
    association :group
    visible_outside true
  end
end

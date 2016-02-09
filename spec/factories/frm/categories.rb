FactoryGirl.define do
  factory :frm_category, class: Frm::Category do
    name { Faker::Company.name }
    group { create(:group_with_province) }
    visible_outside true
  end
end

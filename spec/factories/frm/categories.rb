FactoryGirl.define do
  factory :frm_category, class: Frm::Category do
    name { Faker::Company.name }
    group { create(:group, current_user_id: create(:user).id) }
    visible_outside true
  end
end

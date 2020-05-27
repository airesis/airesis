FactoryBot.define do
  factory :frm_forum, class: 'Frm::Forum' do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    association :category, factory: :frm_category
    group { category.group }
    visible_outside { true }
  end
end

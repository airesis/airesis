FactoryGirl.define do
  factory :group do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    tags_list ['tag1', 'tag2', 'tag3'].join(',')
    interest_border_tkn 'P-57'
    default_role_name { Faker::Name.title }
    default_role_actions DEFAULT_GROUP_ACTIONS
    current_user_id nil

    factory :default_group do

    end

    factory :second_group do

    end
  end
end
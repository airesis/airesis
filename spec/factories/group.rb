  FactoryGirl.define do
  factory :group do
    factory :default_group do
      name Faker::Company.name
      description Faker::Lorem.paragraph
      tags_list ['tag1', 'tag2', 'tag3'].join(',')
      interest_border_tkn 'P-57'
      default_role_name Faker::Name.title
      current_user_id nil
    end

    factory :second_group do
      name Faker::Company.name
      description Faker::Lorem.paragraph
      tags_list ['tag1', 'tag2', 'tag3'].join(',')
      interest_border_tkn 'P-57'
      default_role_name Faker::Name.title
      current_user_id nil
    end
  end
end
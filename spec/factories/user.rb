FactoryGirl.define do
  factory :user do
    password "topolino"
    password_confirmation "topolino"
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    confirmed_at { Time.now }
    user_type_id UserType::AUTHENTICATED
    before(:create) { |user| user.skip_confirmation! }

    factory :default_user do
      email "test@example.com"
    end

    factory :second_user do
      email "test2@example.com"
    end
  end
end
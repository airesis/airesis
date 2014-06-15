FactoryGirl.define do
  factory :user do
    before(:create) do |user|
      user.locale = user.original_locale = SysLocale.find_by_key('en')
      user.skip_confirmation!
    end
    password "topolino"
    password_confirmation "topolino"
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    confirmed_at { Time.now }
    user_type_id UserType::AUTHENTICATED
    email { Faker::Internet.email }

    after(:create) do |user|

    end

    factory :default_user do
    end

    factory :second_user do
    end
  end
end
FactoryBot.define do
  factory :user do
    before(:create) do |user|
      user.locale = user.original_locale = create(:sys_locale, :default)
      user.skip_confirmation!
    end

    password { 'topolino' }
    password_confirmation { 'topolino' }
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    confirmed_at { Time.zone.now }
    user_type_id { User.user_type_ids[:authenticated] }
    email { Faker::Internet.email }

    factory :admin do
      user_type_id { User.user_type_ids[:administrator] }
    end
  end
end

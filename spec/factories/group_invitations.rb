FactoryBot.define do
  factory :group_invitation do
    emails_list { Faker::Internet.email }
    association :group
    inviter_id { nil }
  end
end

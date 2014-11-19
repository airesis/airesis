FactoryGirl.define do
  factory :group_participation_request do
    association :user
    association :group
  end
end

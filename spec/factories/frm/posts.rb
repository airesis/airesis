FactoryGirl.define do
  factory :post, class: Frm::Post do |t|
    association :topic
    text { Faker::Lorem.sentence}
    association :user
    reply_to nil
  end
end

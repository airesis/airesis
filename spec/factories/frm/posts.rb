FactoryBot.define do
  factory :post, class: Frm::Post do
    association :topic, factory: :frm_topic
    text { Faker::Lorem.sentence }
    association :user
    reply_to { nil }
  end
end

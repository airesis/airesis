FactoryGirl.define do
  factory :frm_topic, class: Frm::Topic do
    subject { Faker::Lorem.sentence }
    forum { create(:frm_forum) }
    user { create(:user) }
    posts_attributes { [text: Faker::Lorem.paragraph] }

    factory :approved_topic do
      after(:create) do |t|
        t.approve!
      end
    end
  end
end

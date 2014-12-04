FactoryGirl.define do
  factory :topic, class: Frm::Topic do |t|
    t.subject { Faker::Lorem.sentence }
    t.forum { |f| f.association(:forum) }
    t.user { |u| u.association(:user) }
    t.posts_attributes { [:text => Faker::Lorem.paragraph] }

    factory :approved_topic do
      after(:create) do |t|
        t.approve!
      end
    end
  end
end

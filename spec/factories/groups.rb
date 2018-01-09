FactoryGirl.define do
  factory :group do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    tags_list %w(tag1 tag2 tag3).join(',')
    interest_border_tkn { InterestBorder.to_key(create(:province)) }

    default_role_name { Faker::Name.title }
    default_role_actions DEFAULT_GROUP_ACTIONS
    current_user_id { create(:user).id }

    transient do
      num_participants { 0 }
    end

    after(:create) do |group, evaluator|
      evaluator.num_participants.times do |i|
        user = create(:user)
        group.participation_requests.build(user: user,
                                           group_participation_request_status_id: GroupParticipationRequestStatus::ACCEPTED)
        group.group_participations.build(user: user,
                                         participation_role_id: group.participation_role_id)
      end
      group.save
    end
  end
end

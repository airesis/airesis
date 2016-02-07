FactoryGirl.define do
  factory :best_quorum do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    days_m { 7 }
    percentage { 10 } # at least 10% of participants
    good_score { 50 } # maturity
    t_percentage { 's' }
    t_good_score { 's' }
    t_minutes { 's' }
    vote_percentage { 0 } # quorum zero
    vote_good_score { 50 } # maturity
    t_vote_percentage { 's' }
    t_vote_good_score { 's' }
    t_vote_minutes { 'f' }
    group_quorum { nil }
  end
end

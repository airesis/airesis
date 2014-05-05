class ElectionVote < ActiveRecord::Base
  belongs_to :election, class_name: 'Election', foreign_key: :election_id
  belongs_to :user, class_name: 'User', foreign_key: :user_id
end

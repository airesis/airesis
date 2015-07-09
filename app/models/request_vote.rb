class RequestVote < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :type, class_name: 'RequestVoteType', foreign_key: :request_vote_type_id
  belongs_to :request, class_name: 'GroupParticipationRequest', foreign_key: :group_participation_request_id

end

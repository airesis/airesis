class RequestVote < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id  
  belongs_to :type, :class_name => 'RequestVoteType', :foreign_key => :request_vote_type_id
  belongs_to :request, :class_name => 'GroupPartecipationRequest', :foreign_key => :group_partecipation_request_id
    
end

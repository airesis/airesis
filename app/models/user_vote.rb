class UserVote < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  belongs_to :vote_type, :class_name => 'VoteType', :foreign_key => :vote_type_id
  validates :user_id, :uniqueness => {:scope => :proposal_id}
end

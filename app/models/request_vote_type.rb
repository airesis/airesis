class RequestVoteType < ActiveRecord::Base
  
  has_many :votes, :class_name => 'RequestVote'  
    
end

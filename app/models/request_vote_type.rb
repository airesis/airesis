class RequestVoteType < ApplicationRecord
  has_many :votes, class_name: 'RequestVote'
end

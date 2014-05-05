class SimpleVote < ActiveRecord::Base
  belongs_to :candidate, class_name: 'Candidate', foreign_key: :candidate_id
   
end

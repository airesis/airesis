class SchulzeVote < ActiveRecord::Base
  belongs_to :election, :class_name => 'Election', :foreign_key => :election_id
   
end

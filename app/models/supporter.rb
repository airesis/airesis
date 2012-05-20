class Supporter < ActiveRecord::Base
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
  belongs_to :candidate, :class_name => 'Candidate', :foreign_key => :candidate_id
    
end

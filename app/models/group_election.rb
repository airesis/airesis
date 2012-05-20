class GroupElection < ActiveRecord::Base
  
  belongs_to :group, :class_name => 'Group'
  belongs_to :election, :class_name => 'Election'
  
end

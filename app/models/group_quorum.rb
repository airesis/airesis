class GroupQuorum < ActiveRecord::Base
  
  belongs_to :quorum, :class_name => 'Quorum'
  belongs_to :group, :class_name => 'Group'
  
end

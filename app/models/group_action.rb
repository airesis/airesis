class GroupAction < ActiveRecord::Base
  
  STREAM_POST = 1
  CREATE_EVENT = 2
  PROPOSAL = 3
  REQUEST_ACCEPT = 4
  SEND_CANDIDATES = 5
  
  
  has_many :action_abilitations, :class_name => 'ActionAbilitation'  
end

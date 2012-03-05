class GroupAction < ActiveRecord::Base
  has_many :action_abilitations, :class_name => 'ActionAbilitation'  
end

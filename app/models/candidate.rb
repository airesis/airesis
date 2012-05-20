class Candidate < ActiveRecord::Base
  belongs_to :election, :class_name => 'Election', :foreign_key => :election_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  
  has_many :supporters, :class_name => 'Supporter'
  
  #gruppi di supporto
  has_many :groups, :through => :supporters, :class_name => 'Group'
  
end

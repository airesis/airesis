#encoding: utf-8
class GroupProposal < ActiveRecord::Base
  belongs_to :group, :class_name => 'Group'
  belongs_to :proposal, :class_name => 'Proposal'#, dependent: :destroy
  
end

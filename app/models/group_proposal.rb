#encoding: utf-8
class GroupProposal < ActiveRecord::Base
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  
end

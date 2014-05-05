#encoding: utf-8
class GroupProposal < ActiveRecord::Base
  belongs_to :group, class_name: 'Group', counter_cache: :proposals_count
  belongs_to :proposal, class_name: 'Proposal'#, dependent: :destroy
end

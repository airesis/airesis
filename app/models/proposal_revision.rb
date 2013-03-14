#encoding: utf-8
class ProposalRevision < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :user
  has_many :revision_section_histories, :dependent => :destroy
  has_many :section_histories, :through => :revision_section_histories, :order => :seq
  has_many :solution_histories
end

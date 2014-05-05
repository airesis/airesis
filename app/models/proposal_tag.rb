class ProposalTag < ActiveRecord::Base

	belongs_to :proposal, class_name: 'Proposal'
	belongs_to :tag, class_name: 'Tag'
	
	after_create  :increment_counter_cache
  after_destroy :decrement_counter_cache

  private
  def decrement_counter_cache
    tag.proposals_count = tag.proposals_count - 1
    tag.save
  end

  def increment_counter_cache
    tag.proposals_count = tag.proposals_count + 1
    tag.save
  end

end
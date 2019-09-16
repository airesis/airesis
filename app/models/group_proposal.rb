class GroupProposal < ActiveRecord::Base
  belongs_to :group, class_name: 'Group', counter_cache: :proposals_count, inverse_of: :group_proposals
  belongs_to :proposal, class_name: 'Proposal', inverse_of: :group_proposals

  # TODO: implement a soft delete for proposals
  before_destroy :destroy_proposal

  private

  def destroy_proposal
    if proposal.groups.count == 1
      proposal.destroy
    end
  end
end

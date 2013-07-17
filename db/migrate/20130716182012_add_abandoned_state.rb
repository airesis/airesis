class AddAbandonedState < ActiveRecord::Migration
  def up
    ProposalState.create( :description => "abbandonata"){ |c| c.id = 8 }.save
    Proposal.where(:proposal_state_id => ProposalState::REJECTED, :vote_period_id => nil).each do |proposal|
      proposal.update_attribute(:proposal_state_id, ProposalState::ABANDONED)
    end
  end

  def down
    Proposal.where(:proposal_state_id => ProposalState::ABANDONED).each do |proposal|
      proposal.update_attribute(:proposal_state_id, ProposalState::REJECTED)
    end
    ProposalState.find(8).destroy
  end
end

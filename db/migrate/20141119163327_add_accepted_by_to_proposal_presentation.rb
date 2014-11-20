class AddAcceptedByToProposalPresentation < ActiveRecord::Migration
  def change
    add_column :proposal_presentations, :acceptor_id, :integer
  end
end

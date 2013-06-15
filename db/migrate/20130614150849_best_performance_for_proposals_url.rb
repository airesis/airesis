class BestPerformanceForProposalsUrl < ActiveRecord::Migration
  include Rails.application.routes.url_helpers

  def up
    add_column :proposals, :url, :string
    Proposal.all.each do |proposal|
      proposal.update_column(:url, proposal.private? ? group_proposal_path(proposal.presentation_groups.first,proposal) : proposal_path(proposal))
    end

    change_column :proposals, :url, :string, null: false
  end

  def down
    remove_column :proposals, :url
  end
end

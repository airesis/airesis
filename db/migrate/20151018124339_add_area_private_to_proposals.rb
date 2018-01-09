class AddAreaPrivateToProposals < ActiveRecord::Migration
  def change
    # add_column :proposals, :area_private, :boolean, null: false, default: false
    #
    # Proposal.reset_column_information
    #
    # Proposal.joins(:area_proposals).update_all(area_private: true)
  end
end

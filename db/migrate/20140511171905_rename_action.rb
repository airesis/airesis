class RenameAction < ActiveRecord::Migration
  def change
    action = GroupAction.where(name: 'PROPOSAL_PARTECIPATION').first
    action.name = 'PROPOSAL_PARTICIPATION'
    action.save!
  end
end

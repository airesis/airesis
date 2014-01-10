class Petitions < ActiveRecord::Migration
  def up
    add_column :proposal_types, :groups_available, :boolean, default: true
    add_column :proposal_types, :open_space_available, :boolean, default: false
    #add_column :proposals, :signatures, :integer
    ProposalType.reset_column_information
    ProposalType.create(name: 'PETITION', seq: 10, active: true, color: '#F0EEA4', groups_available: false, open_space_available: true)

  end

  def down
    ProposalType.find_by_name('PETITION').destroy
    #remove_column :proposals, :signatures
    remove_column :proposal_types, :open_space_available
    remove_column :proposal_types, :groups_available
  end
end

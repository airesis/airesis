class AddColorProposalTypes < ActiveRecord::Migration
  def up
    add_column :proposal_types, :color, :string, limit: 10
    ProposalType.reset_column_information
    ProposalType.find_by_name('SIMPLE').update_attribute(:color,'#F0EEA4')
    ProposalType.find_by_name('STANDARD').update_attribute(:color,'#C5F6EF')
    ProposalType.find_by_name('RULE_BOOK').update_attribute(:color,'#F5C5F2')
    ProposalType.find_by_name('PRESS').update_attribute(:color,'#E4E4E4')
    ProposalType.find_by_name('EVENT').update_attribute(:color,'#C9D1DE')
    ProposalType.find_by_name('ESTIMATE').update_attribute(:color,'#C7E4C8')
    ProposalType.find_by_name('AGENDA').update_attribute(:color,'#EDD4B6')
    ProposalType.find_by_name('CANDIDATES').update_attribute(:color,'#F0B5AD')
    ProposalType.find_by_name('POLL').update_attribute(:color,'#F0EEA4')

  end

  def down
    remove_column :proposal_types, :color
  end
end

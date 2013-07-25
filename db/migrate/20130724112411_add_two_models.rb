class AddTwoModels < ActiveRecord::Migration
  def up
    ProposalType.create(short_name: 'SIMPLE', description: 'Semplice', seq: 1, active: true)
    ProposalType.find_by_short_name('STANDARD').update_attributes(seq: 2)
    ProposalType.find_by_short_name('RULE_BOOK').update_attributes(seq: 3)
    ProposalType.find_by_short_name('PRESS').update_attributes(seq: 4)
    ProposalType.find_by_short_name('EVENT').update_attributes(seq: 5)
    ProposalType.find_by_short_name('ESTIMATE').update_attributes(seq: 6)
    ProposalType.find_by_short_name('AGENDA').update_attributes(seq: 7)
    ProposalType.find_by_short_name('CANDIDATES').update_attributes(seq: 8, active: true)
    ProposalType.find_by_short_name('POLL').update_attributes(seq: 9)
  end

  def down
  end
end

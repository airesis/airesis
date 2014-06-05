class CorrectProblems < ActiveRecord::Migration
  def up
    Proposal.find_all_by_rank(nil).each do |proposal|
      proposal.update_attribute(:rank,0)
    end
    change_column :proposals, :rank, :integer, null: false, default: 0
   # rename_table('meetings_participations','meeting_participations') rescue nil
    rename_table('meetings_organizations','meeting_organizations') rescue nil
  end

  def down
  end
end

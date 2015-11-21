class CounterCacheForContributes < ActiveRecord::Migration
  def up
    add_column :proposals, :proposal_contributes_count, :integer, null: false, default: 0

    Proposal.all.each do |proposal|
      proposal.update_columns(proposal_contributes_count: proposal.contributes.count)
    end
  end

  def down
    remove_column :proposals, :proposal_contributes_count
  end
end

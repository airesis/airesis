class RenameVoteTypes < ActiveRecord::Migration
  def up
    VoteType.find(1).update_attribute(:description,"Favorevole")
    VoteType.find(2).update_attribute(:description,"Neutrale")
    VoteType.find(3).update_attribute(:description,"Contrario")
  end

  def down
  end
end

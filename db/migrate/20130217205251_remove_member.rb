class RemoveMember < ActiveRecord::Migration
  def up
    PartecipationRole.find(1).destroy
  end

  def down
  end
end

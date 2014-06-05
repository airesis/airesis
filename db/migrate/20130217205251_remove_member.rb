class RemoveMember < ActiveRecord::Migration
  def up
    ParticipationRole.find(1).destroy
  end

  def down
  end
end

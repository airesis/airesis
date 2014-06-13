class AddIndexToGroupParticipations < ActiveRecord::Migration
  def change
    add_index :group_participations, :group_id
    add_index :group_participations, :user_id
  end
end

class AddTimestampsToGroupParticipations < ActiveRecord::Migration
  def up
    add_column :group_participations, :created_at, :datetime
    add_column :group_participations, :updated_at, :datetime
  end


  def down
    remove_column :group_participations, :created_at
    remove_column :group_participations, :updated_at
  end
end

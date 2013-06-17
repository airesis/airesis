class AddTimestampsToGroupPartecipations < ActiveRecord::Migration
  def up
    add_column :group_partecipations, :created_at, :datetime
    add_column :group_partecipations, :updated_at, :datetime
  end


  def down
    remove_column :group_partecipations, :created_at
    remove_column :group_partecipations, :updated_at
  end
end

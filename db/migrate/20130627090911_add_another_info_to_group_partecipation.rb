class AddAnotherInfoToGroupPartecipation < ActiveRecord::Migration
  def up
    add_column :group_partecipations, :acceptor_id, :integer
  end

  def down
    remove_column :group_partecipations, :acceptor_id
  end
end

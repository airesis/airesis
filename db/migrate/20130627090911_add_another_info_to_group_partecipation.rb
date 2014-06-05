class AddAnotherInfoToGroupParticipation < ActiveRecord::Migration
  def up
    add_column :group_participations, :acceptor_id, :integer
  end

  def down
    remove_column :group_participations, :acceptor_id
  end
end

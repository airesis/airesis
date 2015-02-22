class RemoveOldTokenColumn < ActiveRecord::Migration
  def change
    remove_column :group_invitations, :token
  end
end

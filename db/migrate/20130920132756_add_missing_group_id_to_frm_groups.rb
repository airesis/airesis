class AddMissingGroupIdToFrmGroups < ActiveRecord::Migration
  def up
    add_column :frm_groups, :group_id, :integer
  end

  def down
    remove_column :frm_groups, :group_id

  end
end

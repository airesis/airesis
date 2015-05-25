class ChangeFrmGroupsName < ActiveRecord::Migration
  def change
    rename_table :frm_groups, :frm_mods
  end
end

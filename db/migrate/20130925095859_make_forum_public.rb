class MakeForumPublic < ActiveRecord::Migration
  def up
    add_column :frm_forums, :visible_outside, :boolean, default: true
    add_column :frm_categories, :visible_outside, :boolean, default: true
  end

  def down
    remove_column :frm_categories, :visible_outside
    remove_column :frm_forums, :visible_outside
  end
end

class RemoveWrongIndex < ActiveRecord::Migration
  def up
    remove_index :frm_forums, :slug
    add_index :frm_forums, :slug
    add_index :frm_forums, [:group_id,:slug], unique: true
  end

  def down
    remove_index :frm_forums, :slug
    remove_index :frm_forums, [:group_id,:slug]
    add_index :frm_forums, :slug, unique: true
  end
end

class RemoveWrongIndexTwo < ActiveRecord::Migration
  def up
    remove_index :frm_topics, :slug
    add_index :frm_topics, :slug
    add_index :frm_topics, [:forum_id,:slug], unique: true
  end

  def down
    remove_index :frm_topics, :slug
    remove_index :frm_topics, [:forum_id,:slug]
    add_index :frm_topics, :slug, unique: true
  end
end

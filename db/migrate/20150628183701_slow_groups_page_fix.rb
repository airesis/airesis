class SlowGroupsPageFix < ActiveRecord::Migration
  def change
    add_index :frm_forums, :group_id
    add_index :frm_topics, :created_at
    add_index :frm_views, :viewable_type
    add_index :frm_views, :viewable_id
  end
end

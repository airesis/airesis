class GenerateTopicTags < ActiveRecord::Migration
  def up
    create_table :frm_category_tags do |t|
      t.timestamps
      t.integer :frm_category_id
      t.integer :tag_id
    end


    add_foreign_key :frm_category_tags, :frm_categories
    add_foreign_key :frm_category_tags, :tags

    add_column :tags, :frm_categories_count, :integer, null: false, default: 0

    create_table :frm_forum_tags do |t|
      t.timestamps
      t.integer :frm_forum_id
      t.integer :tag_id
    end


    add_foreign_key :frm_forum_tags, :frm_forums
    add_foreign_key :frm_forum_tags, :tags

    add_column :tags, :frm_forums_count, :integer, null: false, default: 0

    create_table :frm_topic_tags do |t|
      t.timestamps
      t.integer :frm_topic_id
      t.integer :tag_id
    end


    add_foreign_key :frm_topic_tags, :frm_topics
    add_foreign_key :frm_topic_tags, :tags

    add_column :tags, :frm_topics_count, :integer, null: false, default: 0
  end

  def down
    remove_column :tags, :frm_topics_count
    drop_table :frm_topic_tags
    remove_column :tags, :frm_forums_count
    drop_table :frm_forum_tags
    remove_column :tags, :frm_categories_count
    drop_table :frm_category_tags
  end
end

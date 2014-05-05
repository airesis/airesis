class AddForums < ActiveRecord::Migration
  def up
    create_table :frm_forums do |t|
      t.string :name
      t.text :description
      t.integer :category_id
      t.integer :group_id
      t.integer :views_count, default: 0
      t.string :slug
    end

    create_table :frm_topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.string :subject
      t.boolean :locked, null: false, default: false
      t.boolean :pinned, null: false, default: false
      t.boolean :hidden, default: false
      t.string :state, default: 'pending_review'
      t.datetime :last_post_at
      t.integer :views_count, default: 0
      t.string :slug
      t.timestamps
    end

    create_table :frm_posts do |t|
      t.integer :topic_id
      t.text :text
      t.integer :user_id
      t.integer :reply_to_id
      t.string :state, default: 'pending_review'
      t.boolean :notified, default: false

      t.timestamps
    end

    create_table :frm_views do |t|
      t.integer :user_id
      t.integer :viewable_id
      t.string :viewable_type
      t.integer :count, default: 0
      t.datetime :current_viewed_at
      t.datetime :past_viewed_at

      t.timestamps
    end

    create_table :frm_categories do |t|
      t.string :name, null: false
      t.string :slug
      t.integer :group_id
      t.timestamps
    end

    create_table :frm_subscriptions do |t|
      t.integer :subscriber_id
      t.integer :topic_id
    end

    create_table :frm_groups do |t|
      t.string :name
    end

    create_table :frm_memberships do |t|
      t.integer :group_id
      t.integer :member_id
    end

    create_table :frm_moderator_groups do |t|
      t.integer :forum_id
      t.integer :group_id
    end

    add_index :frm_topics, :slug, unique: true
    add_index :frm_categories, :slug, unique: true
    add_index :frm_forums, :slug, unique: true
    add_index :frm_topics, :state
    add_index :frm_posts, :state
    add_index :frm_moderator_groups, :forum_id
    add_index :frm_memberships, :group_id
    add_index :frm_groups, :name
    add_index :frm_topics, :forum_id
    add_index :frm_topics, :user_id
    add_index :frm_posts, :topic_id
    add_index :frm_posts, :user_id
    add_index :frm_posts, :reply_to_id
    add_index :frm_views, :user_id
    add_index :frm_views, :updated_at
  end

  def down
    drop_table :frm_moderator_groups
    drop_table :frm_memberships
    drop_table :frm_groups
    drop_table :frm_subscriptions
    drop_table :frm_categories
    drop_table :frm_views
    drop_table :frm_posts
    drop_table :frm_topics
    drop_table :frm_forums
  end
end

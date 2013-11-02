class AddCommentsForEvents < ActiveRecord::Migration
  def up
    create_table :event_comments do |t|
      t.integer :parent_event_comment_id
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.integer :user_ip
      t.string :user_agent
      t.string :referrer
      t.string :body, limit: 2500, null: false
      t.timestamps
    end

    add_foreign_key :event_comments, :events
    add_foreign_key :event_comments, :event_comments, column: 'parent_event_comment_id'
    add_foreign_key :event_comments, :users
    add_index :event_comments, :event_id
    add_index :event_comments, :user_id
    add_index :event_comments, :parent_event_comment_id


    create_table :event_comment_likes do |t|
      t.integer :event_comment_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end

    add_foreign_key :event_comment_likes, :event_comments
    add_foreign_key :event_comment_likes, :users
    add_index :event_comment_likes, :event_comment_id
    add_index :event_comment_likes, :user_id
    add_index :event_comment_likes, [:event_comment_id, :user_id], unique: true

  end

  def down
    drop_table :event_comment_likes
    drop_table :event_comments
  end
end

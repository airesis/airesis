class CreateReceivedEmail < ActiveRecord::Migration
  def up
    create_table :received_emails do |t|
      t.string :subject
      t.text :body
      t.string :from
      t.string :to
      t.string :token
      t.boolean :read, default: false
      t.timestamps
    end

    add_column :frm_topics, :token, :string
    add_column :frm_posts, :token, :string
    add_index :frm_topics, :token, unique: true
    add_index :frm_posts, :token, unique: true
  end

  def down
    remove_column :frm_posts, :token
    remove_column :frm_topics, :token
    drop_table :received_emails
  end
end

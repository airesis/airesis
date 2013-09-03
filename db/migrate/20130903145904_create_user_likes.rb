class CreateUserLikes < ActiveRecord::Migration
  def up
    create_table :user_likes do |t|

      t.timestamps
      t.integer :user_id, null: false
      t.integer :likeable_id, null: false
      t.string :likeable_type, null: false
    end
    add_foreign_key :user_likes, :users
  end

  def down
    drop_table :user_likes
  end
end

class TagsCounter < ActiveRecord::Migration
  def change
    create_table :tag_counters do |t|
      t.references :tag, null: false
      t.references :territory, polymorphic: true, null: false
      t.integer :proposals_count, default: 0, null: false
      t.integer :blog_posts_count, default: 0, null: false
      t.integer :blogs_count, default: 0, null: false
    end
  end
end

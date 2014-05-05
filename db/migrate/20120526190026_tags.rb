class Tags < ActiveRecord::Migration
  def up
  
    create_table :tags do |t|
      t.string :text, null: false
      t.integer :proposals_count, null: false, default: 0
      t.integer :blog_posts_count, null: false, default: 0
      t.integer :blogs_count, null: false, default: 0
      t.timestamps
    end
    
    add_index :tags, :text, unique: true
   
    create_table :proposal_tags do |t|
      t.integer :proposal_id, null: false
      t.integer :tag_id, null: false
      t.timestamps
    end
    
    add_foreign_key(:proposal_tags,:proposals)
    add_foreign_key(:proposal_tags,:tags)
    add_index :proposal_tags, [:proposal_id,:tag_id], unique: true
    
    add_column :blog_post_tags, :tag_id, :integer
         
    BlogPostTag.all.each do |post|
      tag = Tag.find_or_create_by_text(post.tag)
      tag.save
      post.tag_id = tag.id
      post.save
    end
    
    remove_column :blog_post_tags, :tag
    
    change_column :blog_post_tags, :tag_id, :integer, null: false
            
    #add_foreign_key(:blog_post_tags,:blog_posts)
    add_foreign_key(:blog_post_tags,:tags)
    add_index :blog_post_tags, [:blog_post_id,:tag_id], unique: true
    
    
    add_column :blog_tags, :tag_id, :integer
         
    BlogTag.all.each do |post|
      tag = Tag.find_or_create_by_text(post.tag)
      tag.save
      post.tag_id = tag.id
      post.save
    end
    
    remove_column :blog_tags, :tag
    change_column :blog_tags, :tag_id, :integer, null: false
    
 #   add_foreign_key(:blog_tags,:blogs)
    add_foreign_key(:blog_tags,:tags)
    add_index :blog_tags, [:blog_id,:tag_id], unique: true
    
    
     add_column :proposals, :subtitle, :string, null: false, default: '', limit: 255
     add_column :proposals, :problems, :string, null: false, default: '', limit: 18000
     add_column :proposals, :objectives, :string, null: false, default: '', limit: 18000
     add_column :proposals, :show_comment_authors, :boolean, null: false, default: true
  
  end

  def down
  end
end

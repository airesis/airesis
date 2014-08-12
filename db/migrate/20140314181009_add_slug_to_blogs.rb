class AddSlugToBlogs < ActiveRecord::Migration

    def up
      add_column :blogs, :created_at, :datetime
      add_column :blogs, :updated_at, :datetime

      Blog.all.each do |blog|
        blog.created_at = blog.user.created_at
        blog.updated_at = blog.last_post.try(:updated_at) || blog.created_at
      end


      Blog.find_each do |blog|
        execute "INSERT INTO friendly_id_slugs(
            slug, sluggable_id, sluggable_type, created_at)
            VALUES ('#{blog.id}-#{blog.title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}', #{blog.id}, 'Blog', current_timestamp);"
      end

      add_column :blogs, :slug, :string
      add_index :blogs, :slug

      Blog.reset_column_information
      Blog.find_each(&:save)
    end

    def down
      remove_column :blogs, :slug

      remove_column :blogs, :created_at
      remove_column :blogs, :updated_at
    end

end

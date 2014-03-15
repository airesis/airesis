class AddSlugToBlogs < ActiveRecord::Migration

    def up
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
    end

end

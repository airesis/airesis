class TagsCounter < ActiveRecord::Migration
  def up
    create_table :tag_counters do |t|
      t.references :tag, null: false
      t.references :territory, polymorphic: true, null: false
      t.integer :proposals_count, default: 0, null: false
      t.integer :blog_posts_count, default: 0, null: false
      t.integer :groups_count, default: 0, null: false
    end

    Tag.all.each do |tag|
      tag.tag_counters.create(territory: Country.find_by(description: 'Italy'),
                              proposals_count: tag.proposals_count,
                              blog_posts_count: tag.blog_posts_count,
                              groups_count: tag.groups_count)
    end

    remove_column :tags, :blogs_count
    remove_column :tags, :blog_posts_count
    remove_column :tags, :proposals_count
    remove_column :tags, :groups_count
  end

  def down
    add_column :tags, :blogs_count, :integer, null: false, default: 0
    add_column :tags, :blog_posts_count, :integer, null: false, default: 0
    add_column :tags, :proposals_count, :integer, null: false, default: 0
    add_column :tags, :groups_count, :integer, null: false, default: 0

    TagCounter.all.each do |tag_counter|
      tag_counter.tag.update_columns(proposals_count: tag_counter.proposals_count,
                                     blog_posts_count: tag_counter.blog_posts_count,
                                     groups_count: tag_counter.groups_count)
    end
    drop_table :tag_counters
  end
end

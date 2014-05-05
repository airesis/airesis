class AddSlugToGroups < ActiveRecord::Migration
  def up
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           null: false
      t.integer  :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 40
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type], unique: true
    add_index :friendly_id_slugs, :sluggable_type

    Group.find_each do |group|
    execute "INSERT INTO friendly_id_slugs(
            slug, sluggable_id, sluggable_type, created_at)
            VALUES ('#{group.id}-#{group.name.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}', #{group.id}, 'Group', current_timestamp);"

    end

    add_column :groups, :slug, :string
    add_index :groups, :slug

    Group.reset_column_information
    Group.find_each(&:save)
  end

  def down
    remove_column :groups, :slug
    drop_table :friendly_id_slugs
  end
end

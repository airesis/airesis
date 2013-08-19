class GroupSubdmains < ActiveRecord::Migration
  def up
    add_column :groups, :subdomain, :string, limit: 100
    add_column :groups, :certified, :boolean, null: false, default: false

    create_table :group_tags do |t|
      t.timestamps
      t.integer :group_id
      t.integer :tag_id
    end

    add_foreign_key :group_tags, :groups
    add_foreign_key :group_tags, :tags
    add_index :groups, :subdomain, unique: true
  end

  def down
    drop_table :group_tags
    remove_column :groups, :certified
    remove_column :groups, :subdomain
  end
end

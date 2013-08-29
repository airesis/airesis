class AddMissingCountOnTags < ActiveRecord::Migration
  def up
    add_column :tags, :groups_count, :integer, null: false, default: 0
  end

  def down
    remove_column :tags, :groups_count
  end
end

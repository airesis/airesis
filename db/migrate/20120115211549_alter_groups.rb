class AlterGroups < ActiveRecord::Migration
  def up
        add_column :groups, :facebook_page_url, :string
  end

  def down
     remove_column :groups, :facebook_page_url, :string
  end
end

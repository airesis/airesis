class MoreFieldsForSolutionsAndSections < ActiveRecord::Migration
  def up
    add_column :solutions, :title, :string, limit: 255
    add_column :sections, :question, :string, limit: 20000
  end

  def down
    remove_column :sections, :question
    remove_column :solutions, :title
  end
end

class AddAddedAndRemovedInHistory < ActiveRecord::Migration
  def up
    add_column :solution_histories, :title, :string
    add_column :solution_histories, :added, :boolean
    add_column :solution_histories, :removed, :boolean

    add_column :section_histories, :added, :boolean
    add_column :section_histories, :removed, :boolean
  end

  def down
    remove_column :solution_histories, :title
    remove_column :solution_histories, :added
    remove_column :solution_histories, :removed

    remove_column :section_histories, :added
    remove_column :section_histories, :removed
  end
end

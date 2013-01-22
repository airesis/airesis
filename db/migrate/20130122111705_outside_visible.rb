class OutsideVisible < ActiveRecord::Migration
  def up
    add_column :proposals, :visible_outside, :boolean, :default => true, :null => false
    add_column :groups, :default_visible_outside, :boolean, :default => true, :null => false
  end

  def down
    remove_column :propoals, :visible_outside
    remove_column :groups, :default_visible_outside
  end
end

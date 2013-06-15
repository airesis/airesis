class AnotherPerformanceTip < ActiveRecord::Migration
  def up
    add_index :proposals, :updated_at
  end

  def down
    remove_index :proposals, :updated_at
  end
end

class DropSysFeatures < ActiveRecord::Migration[5.2]
  def change
    drop_table :sys_features
  end
end

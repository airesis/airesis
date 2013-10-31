class CreateSysFeatures < ActiveRecord::Migration
  def up
    create_table :sys_features do |t|
      t.string :title
      t.string :description
      t.float :amount_required
      t.float :amount_received

      t.timestamps
    end
  end

  def down
    drop_table :sys_features
  end
end

class CreateSysMovements < ActiveRecord::Migration
  def up
    create_table :sys_movements do |t|
      t.integer :sys_movement_type_id, null: false
      t.integer :sys_currency_id, null: false
      t.timestamp :made_on, null: false
      t.integer :user_id, null: false
      t.float :amount, null: false

      t.timestamps
    end

    add_foreign_key :sys_movements, :sys_movement_types
    add_foreign_key :sys_movements, :sys_currencies
    add_foreign_key :sys_movements, :users
  end


  def down
    drop_table :sys_movements
  end
end

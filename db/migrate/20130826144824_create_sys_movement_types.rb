class CreateSysMovementTypes < ActiveRecord::Migration
  def up
    create_table :sys_movement_types do |t|
      t.string :description, limit: 20, null: false
      t.timestamps
    end

    SysMovementType.create(description: 'Entrata')
    SysMovementType.create(description: 'Uscita')
  end


  def down
    drop_table :sys_movement_types
  end
end

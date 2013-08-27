class MissingColumnOnMovements < ActiveRecord::Migration
  def up
    add_column :sys_movements, :description, :string,  limit: 10000
  end

  def down
    remove_column :sys_movements, :description
  end
end

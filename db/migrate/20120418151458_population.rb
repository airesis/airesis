class Population < ActiveRecord::Migration
  def up
	add_column :comunes, :population, :integer
	add_column :comunes, :codistat, :string, :limit => 4
	add_column :comunes, :cap, :string, :limit => 5
  end

  def down
  end
end







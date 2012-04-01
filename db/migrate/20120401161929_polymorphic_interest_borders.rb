class PolymorphicInterestBorders < ActiveRecord::Migration
  def up
    add_column :interest_borders, :territory_id, :integer
    add_column :interest_borders, :territory_type, :string
    InterestBorder.all.each do |ib|
      ib.territory_id = ib.foreign_id
      ib.territory_type = 'Comune' if ib.ftype == 'C'
      ib.territory_type = 'Provincia' if ib.ftype == 'P'
      ib.territory_type = 'Regione' if ib.ftype == 'R'
      ib.save
    end
    change_column :interest_borders, :territory_id, :integer, :null => false
    change_column :interest_borders, :territory_type, :string, :null => false
    remove_column :interest_borders, :foreign_id
    remove_column :interest_borders, :ftype 
  end

  def down
    add_column :interest_borders, :foreign_id, :integer
    add_column :interest_borders, :ftype, :string
    InterestBorder.all.each do |ib|
      ib.foreign_id = ib.territory_id
      ib.ftype = 'C' if ib.territory_type == 'Comune'
      ib.ftype = 'P' if ib.territory_type == 'Provincia'
      ib.ftype = 'R' if ib.territory_type == 'Regione'
      ib.save
    end
    change_column :interest_borders, :foreign_id, :integer, :null => false
    change_column :interest_borders, :ftype, :string, :null => false
    remove_column :interest_borders, :territory_id
    remove_column :interest_borders, :territory_type
  end
end

class RenameProvinciaToProvince < ActiveRecord::Migration
  def change
    rename_column :comunes, :provincia_id, :province_id
    rename_column :districts, :provincia_id, :province_id

    rename_table :provincias, :provinces

    SysLocale.where(territory_type: 'Provincia').update_all(territory_type: 'Province')
    InterestBorder.where(territory_type: 'Provincia').update_all(territory_type: 'Province')
    TagCounter.where(territory_type: 'Provincia').update_all(territory_type: 'Province')
  end
end

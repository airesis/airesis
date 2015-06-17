class RenameRegioneToRegion < ActiveRecord::Migration
  def change
    rename_column :provincias, :regione_id, :region_id
    rename_column :comunes, :regione_id, :region_id
    rename_column :districts, :regione_id, :region_id

    rename_table :regiones, :regions

    SysLocale.where(territory_type: 'Regione').update_all(territory_type: 'Region')
    InterestBorder.where(territory_type: 'Regione').update_all(territory_type: 'Region')
  end
end

class RenameStatoToCountry < ActiveRecord::Migration
  def change
    rename_column :stato_translations, :stato_id, :country_id
    rename_column :regiones, :stato_id, :country_id
    rename_column :provincias, :stato_id, :country_id
    rename_column :comunes, :stato_id, :country_id
    rename_column :districts, :stato_id, :country_id

    rename_table :statos, :countries
    rename_table :stato_translations, :country_translations

    SysLocale.where(territory_type: 'Stato').update_all(territory_type: 'Country')
    InterestBorder.where(territory_type: 'Stato').update_all(territory_type: 'Country')
    TagCounter.where(territory_type: 'Stato').update_all(territory_type: 'Country')
  end
end

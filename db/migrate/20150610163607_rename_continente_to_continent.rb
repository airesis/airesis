class RenameContinenteToContinent < ActiveRecord::Migration
  def change
    rename_column :continente_translations, :continente_id, :continent_id
    rename_column :countries, :continente_id, :continent_id
    rename_column :regiones, :continente_id, :continent_id
    rename_column :provincias, :continente_id, :continent_id
    rename_column :comunes, :continente_id, :continent_id
    rename_column :districts, :continente_id, :continent_id

    rename_table :continentes, :continents
    rename_table :continente_translations, :continent_translations

    SysLocale.where(territory_type: 'Continente').update_all(territory_type: 'Continent')
    InterestBorder.where(territory_type: 'Continente').update_all(territory_type: 'Continent')
    TagCounter.where(territory_type: 'Continente').update_all(territory_type: 'Continent')
  end
end

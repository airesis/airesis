class RenameComuneToMunicipality < ActiveRecord::Migration
  def change
    rename_column :districts, :comune_id, :municipality_id

    rename_table :comunes, :municipalities

    SysLocale.where(territory_type: 'Comune').update_all(territory_type: 'Municipality')
    InterestBorder.where(territory_type: 'Comune').update_all(territory_type: 'Municipality')
  end
end

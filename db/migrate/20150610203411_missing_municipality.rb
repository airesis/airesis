class MissingMunicipality < ActiveRecord::Migration
  def change
    rename_column :places, :comune_id, :municipality_id
  end
end

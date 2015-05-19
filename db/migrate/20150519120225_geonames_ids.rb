class GeonamesIds < ActiveRecord::Migration
  def change
    add_column :continentes, :geoname_id, :integer
    add_column :statos, :geoname_id, :integer
    add_column :regiones, :geoname_id, :integer
    add_column :provincias, :geoname_id, :integer
    add_column :comunes, :geoname_id, :integer
    add_column :circoscriziones, :geoname_id, :integer
  end
end


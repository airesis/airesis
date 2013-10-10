#encoding: utf-8
class BetterAndLocalizedInterestBorders < ActiveRecord::Migration
  def up



    add_column :circoscriziones, :provincia_id, :integer
    add_foreign_key :circoscriziones, :provincias
    add_index :circoscriziones, :provincia_id

    add_column :circoscriziones, :regione_id, :integer
    add_foreign_key :circoscriziones, :regiones
    add_index :circoscriziones, :regione_id

    add_column :circoscriziones, :stato_id, :integer
    add_foreign_key :circoscriziones, :statos
    add_index :circoscriziones, :stato_id

    add_column :circoscriziones, :continente_id, :integer
    add_foreign_key :circoscriziones, :continentes
    add_index :circoscriziones, :continente_id

    add_foreign_key :comunes, :regiones
    add_index :comunes, :regione_id

    add_column :comunes, :stato_id, :integer
    add_foreign_key :comunes, :statos
    add_index :comunes, :stato_id

    add_column :comunes, :continente_id, :integer
    add_foreign_key :comunes, :continentes
    add_index :comunes, :continente_id

    add_column :provincias, :stato_id, :integer
    add_column :provincias, :population, :integer
    add_foreign_key :provincias, :statos
    add_index :provincias, :stato_id

    add_column :provincias, :continente_id, :integer
    add_foreign_key :provincias, :continentes
    add_index :provincias, :continente_id


    add_column :regiones, :continente_id, :integer
    add_foreign_key :regiones, :continentes
    add_index :regiones, :continente_id

    execute "update comunes
            set stato_id = subquery.sid, continente_id = subquery.xid
            from (
            select c.id cid, s.id sid,x.id xid
            from comunes c
            join provincias p on c.provincia_id = p.id
            join regiones r on p.regione_id = r.id
            join statos s on r.stato_id = s.id
            join continentes x on s.continente_id = x.id) as subquery
            where comunes.id = subquery.cid"

    execute "update provincias
            set stato_id = subquery.sid, continente_id = subquery.xid
            from (
            select p.id pid, s.id sid,x.id xid
            from provincias p
            join regiones r on p.regione_id = r.id
            join statos s on r.stato_id = s.id
            join continentes x on s.continente_id = x.id) as subquery
            where provincias.id = subquery.pid"

    execute "update regiones
            set continente_id = subquery.xid
            from (
            select r.id rid, x.id xid
            from regiones r
            join statos s on r.stato_id = s.id
            join continentes x on s.continente_id = x.id) as subquery
            where regiones.id = subquery.rid"
  end

  def down


    remove_column :circoscriziones, :provincia_id
    remove_column :circoscriziones, :regione_id
    remove_column :circoscriziones, :stato_id
    remove_column :circoscriziones, :continente_id
    remove_column :comunes, :stato_id
    remove_column :comunes, :continente_id
    remove_column :provincias, :population
    remove_column :provincias, :stato_id
    remove_column :provincias, :continente_id
    remove_column :regiones, :continente_id

    remove_foreign_key :comunes, :regiones
    remove_index :comunes, :regione_id
  end

end

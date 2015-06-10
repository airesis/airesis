class CreateTableStatos < ActiveRecord::Migration
  def up
   create_table :continentes do |t|
      t.integer :id, null: false
      t.string :description, null: false
   end
   
   europa = Continente.create(description: "Europa")

   create_table :statos do |t|
      t.integer :id, null: false
      t.string :description, null: false
      t.integer :continente_id, null: false
      t.string :sigla, length: 5, null: false
   end

   italia = Country.create(description: "Italia", continente_id: europa.id, sigla: "IT")
    
   add_column :regiones, :stato_id, :integer
   
   Regione.update_all("stato_id = #{italia.id}")
 
   change_column :regiones, :stato_id, :integer, null: false
       
   add_foreign_key(:statos,:continentes)
   add_foreign_key(:regiones,:statos)
    
  end

  def down
    remove_column :regiones, :stato_id
    drop_table :statos
    drop_table :continentes

  end

end

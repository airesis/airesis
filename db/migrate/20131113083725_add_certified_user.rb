class AddCertifiedUser < ActiveRecord::Migration
  def up
    create_table :sys_document_types do |t|
      t.string :description
    end

    SysDocumentType.create(description: 'ID Card')
    SysDocumentType.create(description: 'Passport')

    create_table :user_sensitives do |t|
      t.integer :user_id, null: false
      t.string :name, null: false    #duplicate of users
      t.string :surname, null: false #duplicate of users
      t.timestamp :birth_date
      t.integer :birth_place_id
      t.integer :residence_place_id   #residenza
      t.integer :home_place_id        #domicilio
      t.string :tax_code, null: false #cf
      t.string  :document_id
      t.integer :sys_document_type_id
      t.attachment :document
      t.timestamps
    end

    add_index :user_sensitives, :tax_code, unique: true
    add_index :user_sensitives, :user_id, unique: true
    add_foreign_key :user_sensitives, :users
    add_foreign_key :user_sensitives, :sys_document_types
    add_foreign_key :user_sensitives, :interest_borders, column: :birth_place_id
    add_foreign_key :user_sensitives, :interest_borders, column: :residence_place_id
    add_foreign_key :user_sensitives, :interest_borders, column: :home_place_id

    UserType.create(:description => 'Certified', :short_name => 'certified'){|c| c.id = 5}.save!

  end

  def down
    UserType.find_by_short_name('certified').destroy
    drop_table :user_sensitives
    drop_table :sys_document_types
  end
end

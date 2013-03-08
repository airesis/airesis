class CreateGroupAreas < ActiveRecord::Migration
  def up
    #tabella per memorizzare le aree di un gruppo
    create_table :group_areas do |t|
      t.integer :group_id, null: false
      t.string :name, null: false, length: 200
      t.string :description, length: 2000
      t.integer :area_role_id, null: false
      t.timestamps
      t.attachment :image
    end

    #ruoli specifici di quell'area
    create_table :area_roles do |t|
      t.integer :group_area_id
      t.string :name, null: false, length: 200
      t.string :description, length: 2000
      t.timestamps
    end

    #abilitazioni di un ruolo ad una certa azione
    create_table :area_action_abilitations do |t|
      t.integer :group_action_id, null: false
      t.integer :area_role_id, null: false
      t.integer :group_area_id, null: false
      t.timestamps
    end

    #proposte interne ad un'area
    create_table :area_proposals do |t|
      t.integer :proposal_id, null: false
      t.integer :group_area_id, null: false
      t.timestamps
    end

    create_table :area_partecipations do |t|
      t.integer :user_id, null: false
      t.integer :group_area_id, null: false
      t.integer :area_role_id, null: false
      t.timestamps
    end

    add_foreign_key :group_areas, :groups
    add_foreign_key :group_areas, :area_roles
    add_foreign_key :area_roles, :group_areas
    add_foreign_key :area_action_abilitations, :group_actions
    add_foreign_key :area_action_abilitations, :area_roles
    add_foreign_key :area_action_abilitations, :group_areas
    add_foreign_key :area_proposals, :proposals
    add_foreign_key :area_proposals, :group_areas
    add_foreign_key :area_partecipations, :users
    add_foreign_key :area_partecipations, :area_roles
    add_foreign_key :area_partecipations, :group_areas
  end

  def down
    remove_column :group_areas, :area_role_id
    drop_table :area_partecipations
    drop_table :area_proposals
    drop_table :area_action_abilitations
    drop_table :area_roles
    drop_table :group_areas
  end
end

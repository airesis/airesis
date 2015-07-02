class RemoveUnusedTables < ActiveRecord::Migration
  def change
    drop_table 'circoscrizioni_groups' do |t|
      t.integer 'id', null: false
      t.string 'name', limit: 200
      t.string 'description', limit: 2000
      t.string 'accept_requests', limit: 1, default: 'v', null: false
      t.integer 'interest_border_id'
      t.integer 'circoscrizione_id'
    end

    drop_table 'comunali_groups' do |t|
      t.integer 'id', null: false
      t.string 'name', limit: 200
      t.string 'description', limit: 2000
      t.string 'accept_requests', limit: 1, default: 'v', null: false
      t.integer 'interest_border_id'
      t.integer 'comune_id'
    end

    drop_table 'provinciali_groups' do |t|
      t.integer 'id', null: false
      t.string 'name', limit: 200
      t.string 'description', limit: 2000
      t.string 'accept_requests', limit: 1, default: 'v', null: false
      t.integer 'interest_border_id'
      t.integer 'provincia_id'
    end

    drop_table 'regionali_groups' do |t|
      t.integer 'id', null: false
      t.string 'name', limit: 200
      t.string 'description', limit: 2000
      t.string 'accept_requests', limit: 1, default: 'v', null: false
      t.integer 'interest_border_id'
      t.integer 'regione_id'
    end
  end
end

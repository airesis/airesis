class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :q

      t.timestamps
    end
  end
end

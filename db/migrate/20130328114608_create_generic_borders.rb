class CreateGenericBorders < ActiveRecord::Migration
  def up
    create_table :generic_borders do |t|
      t.description
      t.name
      t.seq
    end
  end

  def down
    drop_table :generic_borders
  end
end

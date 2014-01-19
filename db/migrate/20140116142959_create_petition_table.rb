class CreatePetitionTable < ActiveRecord::Migration
  def up
    add_column :proposals, :signatures, :integer
  end

  def down
    remove_column :proposals, :signatures
  end
end

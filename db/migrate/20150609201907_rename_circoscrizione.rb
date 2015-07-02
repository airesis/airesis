class RenameCircoscrizione < ActiveRecord::Migration
  def change
    rename_table :circoscriziones, :districts
  end
end

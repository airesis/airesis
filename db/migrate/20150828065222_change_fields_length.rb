class ChangeFieldsLength < ActiveRecord::Migration
  def change
    change_column :proposals, :title, :string, limit: 255, null: false
    change_column :sections, :title, :string, limit: 255, null: false
  end
end

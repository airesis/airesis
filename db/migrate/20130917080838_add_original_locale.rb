class AddOriginalLocale < ActiveRecord::Migration
  def up
    add_column :users, :original_sys_locale_id, :integer, null: false, default: SysLocale.find_by_key('it-IT').id
  end

  def down
    remove_column :users, :original_sys_locale_id
  end
end

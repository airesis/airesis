class SaveDefaultUserI18n < ActiveRecord::Migration
  def up
    create_table :sys_locales do |t|
      t.string :key
    end

    it = SysLocale.create(:key => 'it')
    SysLocale.create(:key => 'en')
    SysLocale.create(:key => 'us')
    SysLocale.create(:key => 'fr')
    SysLocale.create(:key => 'es')
    SysLocale.create(:key => 'pt')
    SysLocale.create(:key => 'de')

    add_column :users, :sys_locale_id, :integer, null: false, default: it.id
  end

  def down

    remove_column :users, :sys_locale_id

    drop_table :sys_locales
  end
end

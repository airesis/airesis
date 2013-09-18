class AddDefaultHostsForEachLocale < ActiveRecord::Migration
  def up
    add_column :sys_locales, :host, :string
    add_column :sys_locales, :lang, :string
    SysLocale.reset_column_information
    SysLocale.where(key: 'en').first.update_attributes({:host => 'http://www.airesis.eu'})
    SysLocale.where(key: 'us').first.update_attributes({:host => 'http://www.airesis.us'})
    SysLocale.where(key: 'fr').first.update_attributes({:host => 'http://www.airesis.eu', :lang => 'fr'})
    SysLocale.where(key: 'es').first.update_attributes({:host => 'http://www.airesis.eu', :lang => 'es'})
    SysLocale.where(key: 'pt').first.update_attributes({:host => 'http://www.airesis.eu', :lang => 'pt'})
    SysLocale.where(key: 'de').first.update_attributes({:host => 'http://www.airesis.eu', :lang => 'de'})
    SysLocale.where(key: 'it').first.update_attributes({:host => 'http://www.airesis.it'})
  end

  def down
    remove_column :sys_locales, :lang
    remove_column :sys_locales, :host
  end
end

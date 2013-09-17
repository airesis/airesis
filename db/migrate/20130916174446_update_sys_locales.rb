class UpdateSysLocales < ActiveRecord::Migration
  def up
    SysLocale.where(key: 'it').first.update_attribute(:key, 'it-IT')
    SysLocale.where(key: 'us').first.update_attribute(:key, 'en-US')
  end

  def down
    SysLocale.where(key: 'it-IT').first.update_attribute(:key, 'it')
    SysLocale.where(key: 'en-US').first.update_attribute(:key, 'us')

  end
end

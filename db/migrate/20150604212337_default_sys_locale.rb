class DefaultSysLocale < ActiveRecord::Migration
  def change
    add_column :sys_locales, :default, :boolean, nil: false, default: false

    SysLocale.where(host: 'www.airesis.eu').update_all(default: true)
  end
end

class RemoveWww < ActiveRecord::Migration
  def change
    SysLocale.find_each do |sys_locale|
      sys_locale.update(host: sys_locale.host.gsub('www.', ''))
    end
  end
end

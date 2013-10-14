class AddChinese < ActiveRecord::Migration
  def up
    I18n.locale = 'en'
    SysLocale.create(key: 'zh', host: 'www.airesis.cn', territory: Stato.find_by_description('China'))
  end

  def down
  end
end

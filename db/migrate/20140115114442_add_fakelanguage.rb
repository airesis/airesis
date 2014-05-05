class AddFakelanguage < ActiveRecord::Migration
  def up

    I18n.locale = 'en'

    SysLocale.create(key: 'crowdin', host: 'www.airesis.eu', lang: 'crowdin')
  end

  def down
    I18n.locale = 'en'
    SysLocale.where(key: 'crowdin').destroy_all
  end
end

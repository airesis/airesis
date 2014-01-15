class AddFakelanguage < ActiveRecord::Migration
  def up

    I18n.locale = 'en'

    SysLocale.create(:key => 'en-GB', :host => 'www.airesis.eu', lang: 'en-GB')
  end

  def down
    I18n.locale = 'en'
    SysLocale.where(:key => 'en-GB').destroy_all
  end
end

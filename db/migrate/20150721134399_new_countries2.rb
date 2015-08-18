class NewCountries2 < ActiveRecord::Migration
  def change
    SysLocale.create(key: 'en-IE', host: 'http://www.airesis.eu', lang: 'en-IE', territory: Country.find_by(description: 'Ireland'))
    eval(File.read('db/seeds/234_ireland.rb'))

    SysLocale.create(key: 'sr', host: 'http://www.airesis.eu', lang: 'sr', territory: Country.find_by(description: 'Serbia'))
    eval(File.read('db/seeds/235_serbia.rb'))

    SysLocale.create(key: 'id', host: 'http://www.airesis.eu', lang: 'id', territory: Country.find_by(description: 'Indonesia'))
    eval(File.read('db/seeds/236_indonesia.rb'))
  end
end

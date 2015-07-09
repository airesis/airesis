class NewCountries < ActiveRecord::Migration
  def change
    SysLocale.create(key: 'el', host: 'http://www.airesis.eu', lang: 'el', territory: Stato.find_by(description: 'Greece'))
    eval(File.read('db/seeds/228_greece.rb'))
    SysLocale.create(key: 'en-GB', host: 'http://www.airesis.eu', lang: 'en-GB', territory: Stato.find_by(description: 'United Kingdom'))
    eval(File.read('db/seeds/229_united_kingdom.rb'))
    SysLocale.create(key: 'en-ZA', host: 'http://www.airesis.eu', lang: 'en-ZA', territory: Stato.find_by(description: 'South Africa'))
    eval(File.read('db/seeds/230_south_africa.rb'))
    SysLocale.create(key: 'en-NZ', host: 'http://www.airesis.eu', lang: 'en-NZ', territory: Stato.find_by(description: 'New Zealand'))
    eval(File.read('db/seeds/231_new_zealand.rb'))
    SysLocale.create(key: 'en-AU', host: 'http://www.airesis.eu', lang: 'en-AU', territory: Stato.find_by(description: 'Australia'))
    eval(File.read('db/seeds/232_australia.rb'))
  end
end

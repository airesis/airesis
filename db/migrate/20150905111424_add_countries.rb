class AddCountries < ActiveRecord::Migration
  def change
    load 'db/seeds/237_bosnia_and_herzegovina.rb'
    load 'db/seeds/238_france.rb'
    load 'db/seeds/239_germany.rb'
    load 'db/seeds/240_ecuador.rb'
    load 'db/seeds/241_spain.rb'
  end
end

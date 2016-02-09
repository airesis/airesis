class AddSouthamericaAndRussiaCountries < ActiveRecord::Migration
  def change
    load 'db/seeds/2_argentina.rb'
    load 'db/seeds/3_brazil.rb'
    load 'db/seeds/4_chile.rb'
    load 'db/seeds/5_russian_federation.rb'
  end
end

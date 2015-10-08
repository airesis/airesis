class AddEastCountries < ActiveRecord::Migration
  def change
    load 'db/seeds/242_croatia.rb'
    load 'db/seeds/243_montenegro.rb'
    load 'db/seeds/244_hungary.rb'
    load 'db/seeds/245_romania.rb'
    load 'db/seeds/246_china.rb'
  end
end

class CreateHungary < ActiveRecord::Migration
  def change
    SysLocale.create(key: "hu", host: "www.airesis.eu", territory_type: "Stato", territory_id: Stato.find_by(sigla_ext: 'HUN'), lang: "hu")
  end
end

class CreateHungary < ActiveRecord::Migration
  def change
    SysLocale.create(key: "ru", host: "www.airesis.eu", territory_type: "Stato", territory_id: Stato.find_by(sigla_ext: 'RUS'), lang: "ru")
  end
end

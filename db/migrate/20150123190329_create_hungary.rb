class CreateHungary < ActiveRecord::Migration
  def change
    SysLocale.create(key: "hu", host: "www.airesis.eu", territory_type: "Stato", territory_id: "210", lang: "hu")
  end
end

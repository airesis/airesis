#encoding: utf-8
class AddSanmarinoAndOtherStates < ActiveRecord::Migration
  def up
    san_marino = Stato.create(:description => "San Marino", :continente_id => 1, :sigla => "SMR")
    vaticano = Stato.create(:description => "Città del Vaticano", :continente_id => 1, :sigla => "SCV")
  end

  def down
    Stato.find_by_description("San Marino").destroy
    Stato.find_by_description("Città del Vaticano").destroy
  end
end

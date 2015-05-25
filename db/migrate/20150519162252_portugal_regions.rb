class PortugalRegions < ActiveRecord::Migration
  def change
    eval(File.read('db/seeds/233_portugal.rb'))
  end
end

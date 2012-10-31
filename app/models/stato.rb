class Stato < ActiveRecord::Base
  set_table_name 'statos'
  belongs_to :continente, :class_name => 'Continente', :foreign_key => :continente_id
  has_many :regiones, :class_name => 'Regione'
end

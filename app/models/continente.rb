class Continente < ActiveRecord::Base
  set_table_name 'continentes'
  has_many :statos, :class_name => 'Stato'
end

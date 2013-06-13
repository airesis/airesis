class Continente < ActiveRecord::Base
  self.table_name = 'continentes'
  has_many :statos, :class_name => 'Stato'
end

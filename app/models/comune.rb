class Comune < ActiveRecord::Base
  has_many :places, :class_name => 'Place'
  belongs_to :provincias, :class_name => 'Provincia', :foreign_key => :provincia_id
  has_many :circoscriziones, :class_name => 'Circoscrizione'
  #has_many :comunali_groups, :class_name => 'ComunaliGroup'
end

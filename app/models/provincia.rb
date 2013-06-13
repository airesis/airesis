class Provincia < ActiveRecord::Base
  self.table_name = 'provincias'
  belongs_to :regione, :class_name => 'Regione', :foreign_key => :regione_id
  has_many :comunes, :class_name => 'Comune'
  #has_many :provinciali_groups, :class_name => 'ProvincialiGroup'
end

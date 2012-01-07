class RegionaliGroup < ActiveRecord::Base
  belongs_to :regiones, :class_name => 'Regione', :foreign_key => :regione_id
end

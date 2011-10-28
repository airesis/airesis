class CircoscrizioniGroup < ActiveRecord::Base
  belongs_to :circoscriziones, :class_name => 'Circoscrizione', :foreign_key => :circoscrizione_id
end

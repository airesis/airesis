class Circoscrizione < ActiveRecord::Base
  belongs_to :comunes, :class_name => 'Comune', :foreign_key => :comune_id
  has_many :circoscrizioni_groups, :class_name => 'CircoscrizioniGroup'
end

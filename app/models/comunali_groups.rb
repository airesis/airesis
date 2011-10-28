class ComunaliGroup < ActiveRecord::Base
  belongs_to :comunes, :class_name => 'Comune', :foreign_key => :comune_id
end

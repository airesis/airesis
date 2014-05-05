class ProvincialiGroup < ActiveRecord::Base
  belongs_to :provincias, class_name: 'Provincia', foreign_key: :provincia_id
end

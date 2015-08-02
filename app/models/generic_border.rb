class GenericBorder < ActiveRecord::Base
  def name_j
    "#{description} (#{name})"
  end
end

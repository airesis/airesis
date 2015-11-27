class GenericBorder < ActiveRecord::Base

  scope :by_hint, ->(hint) { where('lower_unaccent(description) like lower_unaccent(?)', hint) }

  def name_j
    "#{description} (#{name})"
  end
end

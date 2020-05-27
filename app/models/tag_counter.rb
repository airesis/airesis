class TagCounter < ApplicationRecord
  belongs_to :tag
  belongs_to :territory, polymorphic: true

  validates :tag, presence: true
  validates :territory, presence: true
end

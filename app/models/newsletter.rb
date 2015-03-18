class Newsletter < ActiveRecord::Base
  validates :subject, presence: true
  validates :body, presence: true

end

class Step < ApplicationRecord
  belongs_to :tutorial, class_name: 'Tutorial'
  has_many :tutorial_progresses, class_name: 'TutorialProgress', dependent: :destroy

  def is_html?
    format == 'html'
  end
end

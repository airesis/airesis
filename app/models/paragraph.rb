class Paragraph < ActiveRecord::Base
  belongs_to :section

  attr_accessor :content_dirty

  validates_length_of :content, :within => 1..40000, :allow_blank => true

  def content_dirty
    @content_dirty ||= self.content
  end

  def content_dirty= val
    @content_dirty = val
  end
end
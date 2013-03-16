class  Paragraph < ActiveRecord::Base
  belongs_to :section

  attr_accessor :content_dirty


  def content_dirty
    @content_dirty ||= self.content
  end

  def content_dirty=val
    @content_dirty = val
  end
end
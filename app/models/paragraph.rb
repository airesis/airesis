class Paragraph < ActiveRecord::Base
  belongs_to :section

  has_many :proposal_comments

  attr_accessor :content_dirty

  validates_length_of :content, :within => 1..40000, :allow_blank => true

  before_destroy :remove_related_comments

  def remove_related_comments
    self.proposal_comments.update_all(:paragraph_id => nil)
  end

  def content_dirty
    @content_dirty ||= self.content
  end

  def content_dirty= val
    @content_dirty = val
  end

  def content=(content)
    write_attribute(:content,content ? content.gsub('&nbsp;',' ') : nil)
  end

end
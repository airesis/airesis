class Paragraph < ActiveRecord::Base
  belongs_to :section

  has_many :proposal_comments

  attr_accessor :content_dirty

  validates_length_of :content, within: 1..40_000, allow_blank: true

  before_destroy :remove_related_comments

  def remove_related_comments
    proposal_comments.update_all(paragraph_id: nil)
  end

  def content_dirty
    @content_dirty ||= content
  end

  attr_writer :content_dirty

  def content=(content)
    ed_content = content ? content.gsub('&nbsp;', ' ').strip.gsub('<br></p>', '</p>') : nil
    ed_content = '<p></p>' if ed_content.to_s == ''
    write_attribute(:content, ed_content)
  end

  def empty?
    (content == '<p></p>') || content.empty?
  end
end

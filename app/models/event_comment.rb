class EventComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :comment, class_name: 'EventComment', foreign_key: :parent_event_comment_id

  has_many :likes, class_name: 'EventCommentLike', foreign_key: :event_comment_id, dependent: :destroy
  has_many :likers, class_name: 'User', through: :likes, source: :user

  validates_presence_of :body

  attr_accessor :collapsed

  def after_initialize
    @collapsed = false
  end

  def formatted_created_at
    created_at.strftime('%m/%d/%Y alle %I:%M%p')
  end

  def parsed_body
    body
  end

  # Used to set more tracking for akismet
  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end
end

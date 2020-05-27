class BlogComment < ApplicationRecord
  belongs_to :user
  belongs_to :blog_post, counter_cache: true
  has_one :blog, through: :blog_post

  validates :body, presence: true, length: { maximum: 10.kilobytes }

  attr_accessor :collapsed

  after_commit :send_notifications, only: :create

  def after_initialize
    @collapsed = false
  end

  def formatted_created_at
    created_at.strftime('%m/%d/%Y alle %I:%M%p')
  end

  def parsed_body
    body
  end

  def user_name
    name = user ? user.name : name
    if site_url.present?
      "<a href=\"#{site_url}\">#{name}</a>"
    else
      name
    end
  end

  # Used to set more tracking for akismet
  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end

  protected

  def send_notifications
    NotificationBlogCommentCreate.perform_async(id)
  end
end

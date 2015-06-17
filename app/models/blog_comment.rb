class BlogComment < ActiveRecord::Base
  include BlogKitModelHelper

  belongs_to :user
  belongs_to :blog_post, counter_cache: true
  has_one :blog, through: :blog_post

  validates_presence_of :body

  #before_save :check_for_spam

  attr_accessor :collapsed

  after_commit :send_notifications, only: :create

  def after_initialize
    @collapsed = false
  end

  def formatted_created_at
    self.created_at.strftime('%m/%d/%Y alle %I:%M%p')
  end

  def parsed_body
    # # Going to add markdown/html support later for comments
    # self.code_highlight_and_markdown(self.body, {escape_html: true})
    self.body
  end

  def user_name
    name = self.user ? self.user.name : self.name
    if !self.site_url.blank?
      "<a href=\"#{self.site_url}\">#{name}</a>"
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

  def check_for_spam
    if BlogKit.instance.settings['akismet_key'] && BlogKit.instance.settings['blog_url']
      if Akismetor.spam?(akismet_attributes)
        self.errors.add_to_base('This comment has been detected as spam')
        return false
      else
        return true
      end
    end
    true
  end

  def akismet_attributes
    {key: BlogKit.instance.settings['akismet_key'],
     blog: BlogKit.instance.settings['blog_url'],
     user_ip: user_ip,
     user_agent: user_agent,
     comment_author: name,
     comment_author_email: email,
     comment_author_url: site_url,
     comment_content: body}
  end


  protected

  def send_notifications
    NotificationBlogCommentCreate.perform_async(id)
  end
end

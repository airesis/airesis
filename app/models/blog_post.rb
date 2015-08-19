class BlogPost < ActiveRecord::Base
  include Concerns::Taggable
  PUBLISHED = 'P'
  RESERVED = 'R'
  DRAFT = 'D'

  has_paper_trail class_name: 'BlogPostVersion'

  belongs_to :user
  belongs_to :blog

  has_many :blog_comments, dependent: :destroy
  has_many :blog_post_tags, dependent: :destroy
  has_many :tags, through: :blog_post_tags, class_name: 'Tag'

  has_many :publishings, class_name: 'PostPublishing', dependent: :destroy
  has_many :groups, through: :publishings, class_name: 'Group'

  validates_presence_of :title
  validates_presence_of :body

  scope :published, -> { where(status: [PUBLISHED, RESERVED]).order('published_at DESC') }
  scope :drafts, -> { where(status: DRAFT).order('published_at DESC') }

  scope :open_space, lambda { |user, domain|
    includes(:blog, user: [:user_type, :image]).
      where(users: {original_sys_locale_id: domain.id}).
      accessible_by(Ability.new(user)).
      order('blog_posts.created_at desc').limit(10)
  }

  before_save :check_published

  after_commit :send_notifications, on: :create

  def published?
    status == PUBLISHED
  end

  def draft?
    status == DRAFT
  end

  def reserved?
    status == RESERVED
  end

  def check_published
    return if published_at.present?
    if new_record?
      return if draft?
    else
      return unless status_change.present?
      return unless [[DRAFT, PUBLISHED], [DRAFT, RESERVED], [PUBLISHED, RESERVED]].include? status_change
    end
    self.published_at = Time.now
  end

  def formatted_updated_at
    updated_at.strftime('%m/%d/%Y alle %I:%M%p')
  end

  # Provide SEO Friendly URL's
  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end

  protected

  def send_notifications
    NotificationBlogPostCreate.perform_async(id) unless draft?
  end
end

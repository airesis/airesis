class BlogPost < ActiveRecord::Base
  PUBLISHED = 'P'
  RESERVED = 'R'
  DRAFT = 'D'

  has_paper_trail class_name: 'BlogPostVersion'

  belongs_to :user
  belongs_to :blog

  has_many :blog_comments, dependent: :destroy
  has_many :blog_post_tags, dependent: :destroy
  has_many :tags, through: :blog_post_tags, class_name: 'Tag'

  has_many :publishings, class_name: "PostPublishing", dependent: :destroy
  has_many :groups, through: :publishings, class_name: "Group"

  validates_presence_of :title
  validates_presence_of :body

  scope :published, -> { where(status: [PUBLISHED, RESERVED]).order('published_at DESC') }
  scope :drafts, -> { where(status: DRAFT).order('published_at DESC') }

  scope :viewable_by, ->(user) {
    where("blog_posts.status = ? or (blog_posts.status = ? and group_participations.user_id = ?)",
          PUBLISHED, RESERVED, user.id).
      joins(groups: [:group_participations]) }

  scope :open_space, ->(user, domain) {
    includes(:blog, user: [:user_type, :image]).
      where(users: {original_sys_locale_id: domain.id}).
    accessible_by(Ability.new(user)).
      order('blog_posts.created_at desc').limit(10)
  }

  before_save :check_published
  before_save :save_tags

  after_commit :send_notifications, on: :create

  def published?
    self.status == PUBLISHED
  end

  def draft?
    self.status == DRAFT
  end

  def reserved?
    self.status == RESERVED
  end

  def tags_list
    @tags_list ||= self.tags.map(&:text).join(', ')
  end

  def tags_list_json
    @tags_list ||= self.tags.map(&:text).join(', ')
  end

  def tags_list=(tags_list)
    @tags_list = tags_list
  end

  def tags_with_links
    html = self.tags.collect { |t| "<a href=\"/tags/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
    return html
  end

  def save_tags
    return unless @tags_list

    # Remove old tags
    #self.blog_post_tags.destroy_all

    # Save new tags
    tids = []
    @tags_list.split(/,/).each do |tag|
      stripped = tag.strip.downcase.gsub('.', '')
      t = Tag.find_or_create_by(text: stripped)
      tids << t.id
    end
    self.tag_ids = tids
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

  def show_user?
    self.user
  end

  def formatted_updated_at
    self.updated_at.strftime('%m/%d/%Y alle %I:%M%p')
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

class Blog < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  include PgSearch

  pg_search_scope :search, lambda { |query, any_word = false|
    { query: query,
      against: :title,
      order_within_rank: 'updated_at desc',
      using: { tsearch: { any_word: any_word } } }
  }

  belongs_to :user
  has_many :blog_posts, dependent: :destroy
  has_many :comments, through: :blog_posts, source: :blog_comments

  validates :title, length: { in: 1..100 }
  validates :user, presence: true

  def last_post
    blog_posts.order(created_at: :desc).first
  end

  def solr_country_id
    territory = user.original_locale.territory
    territory.id if territory.is_a?(Country)
  end

  def solr_continent_id
    territory = user.original_locale.territory
    territory.is_a?(Country) ? territory.continent.id : territory.id
  end

  def self.look(params)
    search = params[:search]
    tag = params[:tag]
    page = params[:page] || 1
    limit = params[:limit] || 30
    interest_border = params[:interest_border]

    if tag
      Blog.joins(blog_posts: :tags).
        where(['tags.text = ?', tag]).uniq.
        order(updated_at: :desc).page(page).per(limit)
    else
      blogs = if search.blank?
                Blog.order(updated_at: :desc)
              else
                search(search, !params[:and])
              end
      if interest_border
        blogs = blogs.joins(:user).merge(User.by_interest_borders(interest_border))
      end
      blogs.page(page).per(limit)
    end
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end

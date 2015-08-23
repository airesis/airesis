class Blog < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  belongs_to :user
  has_many :blog_posts, dependent: :destroy
  has_many :comments, through: :blog_posts, source: :blog_comments

  validates :title, length: {in: 1..100}
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

  searchable do
    text :title, boost: 2
    time :created_at
    time :last_post_created_at do
      last_post.try(:created_at)
    end
    text :fullname do
      user.fullname
    end

    integer :continent_ids do
      solr_continent_id
    end
    integer :country_ids do
      solr_country_id
    end
    integer :region_ids do
      nil
    end
    integer :province_ids do
      nil
    end
    integer :municipality_ids do
      nil
    end
  end

  def self.look(params)
    search = params[:search]
    params[:minimum] = params[:and] ? nil : 1

    tag = params[:tag]

    page = params[:page] || 1
    limite = params[:limit] || 30
    minimum = params[:minimum]
    interest_border = params[:interest_border_obj]
    if tag
      Blog.joins(blog_posts: :tags).where(['tags.text = ?', tag]).uniq.page(page).per(limite)
    else
      Blog.search do
        fulltext search, minimum_match: minimum if search
        with(interest_border.solr_search_field, interest_border.territory.id) if interest_border.present?
        order_by :score, :desc
        order_by :last_post_created_at, :desc
        order_by :created_at, :desc

        paginate page: page, per_page: limite
      end.results
    end
  end
end

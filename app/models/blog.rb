class Blog < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  include BlogKitModelHelper

  belongs_to :user
  has_many :blog_posts, dependent: :destroy
  has_many :comments, through: :blog_posts, source: :blog_comments

  has_many :blog_tags, dependent: :destroy
  has_many :tags, through: :blog_tags, class_name: 'Tag'

  def last_post
    self.blog_posts.order(created_at: :desc).first
  end

  def solr_country_id
    territory = user.original_locale.territory
    territory.id if territory.is_a?(Country)
  end

  def solr_continente_id
    territory = user.original_locale.territory
    territory.is_a?(Country) ? territory.continente.id : territory.id
  end

  searchable do
    text :title, boost: 2
    time :created_at
    time :last_post_created_at do
      self.last_post.try(:created_at)
    end
    text :fullname do
      self.user.fullname
    end

    integer :continente_id do
      solr_continente_id
    end
    integer :country_id do
      solr_country_id
    end
    integer :regione_id do
      nil
    end
    integer :provincia_id do
      nil
    end
    integer :comune_id do
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

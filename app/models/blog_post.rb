#encoding: utf-8
class BlogPost < ActiveRecord::Base
	include BlogKitModelHelper

  has_paper_trail :class_name => 'BlogPostVersion'

	belongs_to :user
  belongs_to :blog
	
	has_many :blog_comments, :dependent => :destroy
	has_many :blog_post_tags, :dependent => :destroy
	has_many :tags, :through => :blog_post_tags, :class_name => 'Tag'
	
  has_many :blog_post_images
	has_many :blog_images, :through => :blog_post_images, :source => :image, :dependent => :destroy
	has_many :publishings, :class_name => "PostPublishing", :dependent => :destroy
  has_many :groups, :through => :publishings,:class_name => "Group"
	accepts_nested_attributes_for :blog_images, :allow_destroy => true
	
	
	validates_presence_of :title
	validates_presence_of :body
	
	scope :published, -> { where(:status => ['P','R']).order('published_at DESC') }
	scope :drafts, -> { where(:status => 'D').order('published_at DESC')}
  scope :viewable_by, ->(user) { where("blog_posts.status = 'P' or (blog_posts.status = 'R' and group_partecipations.user_id = ?)",user.id).joins(:groups => [:group_partecipations])}
	
	before_save :check_published, :if => :not_resaving?
	before_save :save_tags, :if => :not_resaving?

  def published?
    self.status == 'P'
  end

  def draft?
    self.status == 'D'
  end

  def reserved?
    self.status == 'R'
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
		html = self.tags.collect {|t| "<a href=\"/tags/#{t.text.strip}\">#{t.text.strip}</a>" }.join(', ')
		return html
	end
	
	def save_tags
		if @tags_list
			# Remove old tags
			#self.blog_post_tags.destroy_all
		
			# Save new tags
			tids = []
			@tags_list.split(/,/).each do |tag|
			  stripped = tag.strip.downcase.gsub('.','')
			  t = Tag.find_or_create_by(text: stripped)
			  tids << t.id
			end
			self.tag_ids = tids
		end
	end
	
	def not_resaving?
		!@resaving
	end
	

	def check_published
		if self.status_change && ([['D', 'P'],['D', 'R'], ['P','R']].include? self.status_change)
			# Moved to published state, update published_on
			self.published_at = Time.now
		end
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
end

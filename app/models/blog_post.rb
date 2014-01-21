#encoding: utf-8
class BlogPost < ActiveRecord::Base
	include BlogKitModelHelper

  has_paper_trail :class_name => 'BlogPostVersion'
	
	unloadable
	
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
	
	scope :published, -> { where(:published => true).order('published_at DESC') }
	scope :drafts, -> { where(:published => false).order('published_at DESC')}
	
	before_save :check_published, :if => :not_resaving?
	before_save :save_tags, :if => :not_resaving?

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
			  t = Tag.find_or_create_by_text(stripped)
			  tids << t.id
			end
			self.tag_ids = tids
		end
	end
	
	def not_resaving?
		!@resaving
	end
	

	def check_published
		if self.published_change && self.published_change == [false, true]
			# Moved to published state, update published_on
			self.published_at = Time.now
		end
	end
	
	def show_user?
		self.user
	end

  #TODO to remove in 3.0
	def parsed_body
		image_parsed_body = self.body.gsub(/[{]blog_image[:]([0-9]+)[:]([a-zA-Z]+)[}]/) do |str|
			puts "IMAGE ID: #{$1.to_i}"
			img = Image.find_by_id($1.to_i)

			if img
				img.image.url($2)
			else
				''
			end
		end
		ret = code_highlight_and_markdown(image_parsed_body).force_encoding(Encoding::UTF_8)
		return ret
	end

	def formatted_updated_at
		self.updated_at.strftime('%m/%d/%Y alle %I:%M%p')
	end
	
	# Provide SEO Friendly URL's
	def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end
end

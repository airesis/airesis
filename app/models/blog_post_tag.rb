class BlogPostTag < ActiveRecord::Base
	unloadable

	belongs_to :blog_post
	belongs_to :tag
end
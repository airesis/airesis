class BlogTag < ActiveRecord::Base
	unloadable

	belongs_to :blog
	belongs_to :tag
end
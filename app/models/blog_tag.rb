class BlogTag < ActiveRecord::Base
	unloadable

	belongs_to :blog
end
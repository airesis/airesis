class GroupTag < ActiveRecord::Base
	unloadable

	belongs_to :group
	belongs_to :tag
end
# a tag assigned to a block. currently not in use
class BlogTag < ActiveRecord::Base
  belongs_to :blog
  belongs_to :tag
end

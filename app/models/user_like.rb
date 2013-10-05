class UserLike < ActiveRecord::Base

  attr_accessible :likeable_id, :likeable_type
end

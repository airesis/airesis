class EventCommentLike < ActiveRecord::Base

  belongs_to :user
  belongs_to :event_comment

end

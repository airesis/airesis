class MeetingsPartecipation < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :meeting, :class_name => 'Meeting', :foreign_key => :meeting_id
end

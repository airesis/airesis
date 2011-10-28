class MeetingsPartecipation < ActiveRecord::Base
  belongs_to :users, :class_name => 'User', :foreign_key => :user_id
  belongs_to :meetings, :class_name => 'Meeting', :foreign_key => :meeting_id
end

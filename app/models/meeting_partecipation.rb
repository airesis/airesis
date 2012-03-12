class MeetingPartecipation < ActiveRecord::Base
  include BlogKitModelHelper
  
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :meeting, :class_name => 'Meeting', :foreign_key => :meeting_id
  
  validates_presence_of :user_id, :meeting_id, :comment, :guests, :response
  validates_length_of :comment, :maximum => 255
end

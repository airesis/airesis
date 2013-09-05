class MeetingPartecipation < ActiveRecord::Base
  include BlogKitModelHelper
  
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :meeting, :class_name => 'Meeting', :foreign_key => :meeting_id
  
  validates_presence_of :user_id, :meeting_id, :guests, :response
  #validates_presence_of :comment, :if => :will_come
  validates_length_of :comment, :maximum => 255

  def will_come
    self.response == 'Y'
  end
end

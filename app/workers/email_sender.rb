class EmailSender
  @queue = :notifications
    
  def self.perform(alert_id)    
    ResqueMailer.notification(alert_id).deliver
    #alert = UserAlert.find(alert_id)
    #puts "Done!"
  end
end
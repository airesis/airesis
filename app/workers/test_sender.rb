class TestSender
  @queue = :tests
    
  def self.perform
    TestMailer.test.deliver
    #alert = UserAlert.find(alert_id)
    #puts "Done!"
  end
end
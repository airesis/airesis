class TestMailer < ActionMailer::Base
 # include Resque::Mailer
  default from: "coorasse+airesis@gmail.com"
  
  
  def test    
    mail(:to => "coorasse@gmail.com", :subject => "Test Redis TO Go")
  end
  
end

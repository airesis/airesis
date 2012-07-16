class TestMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "info@airesis.it"
  
  
  def test    
    mail(:to => "coorasse@gmail.com", :subject => "Test Redis TO Go")
  end
  
end

class ResqueMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "info@airesis.it"
  
  
  def notification(alert_id)
    @alert = UserAlert.find(alert_id)
    mail(:to => @alert.user.email, :subject => APP_SHORT_NAME + " - Notifica")
  end
  
  def admin_message(msg)
    @msg = msg
    mail(:to => 'coorasse+daily@gmail.com', :subject => APP_SHORT_NAME + " - Messaggio di amministrazione")
  end
end

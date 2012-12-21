class ResqueMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "info@airesis.it"
  
  
  def notification(alert_id)
    @alert = UserAlert.find(alert_id)
    mail(:to => @alert.user.email, :subject => "Airesis - Notifica")
#      from "coorasse+admin@gmail.com"
#      subject "DemocracyOnline - Notifica"
#      body alert.notification.message
  end
  
  def admin_message(msg)
    @msg = msg
    mail(:to => 'coorasse+daily@gmail.com', :subject => "Airesis - Messaggio di amministrazione")
#      from "coorasse+admin@gmail.com"
#      subject "DemocracyOnline - Notifica"
#      body alert.notification.message
  end
end

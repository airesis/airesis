class CronMailer < ActionMailer::Base
 
  def daily_email(msg)
      recipients "coorasse+admin@gmail.com"
      from "coorasse+cron@gmail.com"
      subject "Daily Email"
      body msg
  end
  
  def notification_email(alert)
      recipients alert.user.email
      from "coorasse+admin@gmail.com"
      subject "DemocracyOnline - Notifica"
      body alert.notification.message
  end
end

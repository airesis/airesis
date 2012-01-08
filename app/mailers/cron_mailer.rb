class CronMailer < ActionMailer::Base
 
  def daily_email(msg)
      recipients "coorasse+admin@gmail.com"
      from "coorasse+cron@gmail.com"
      subject "Daily Email"
      body msg
  end
end

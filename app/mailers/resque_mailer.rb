class ResqueMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "Airesis <info@airesis.it>"

  layout 'resque_mailer/notification'
  
  def notification(alert_id)
    @alert = UserAlert.find(alert_id)
    mail(:to => @alert.user.email, :subject => @alert.notification.notification_type.email_subject)
  end
  
  def admin_message(msg)
    @msg = msg
    mail(:to => 'coorasse+daily@gmail.com', :subject => APP_SHORT_NAME + " - Messaggio di amministrazione")
  end


  def info_message(msg)
    mail(:to => 'coorasse+info@gmail.com', :subject => APP_SHORT_NAME + " - Messaggio di informazione")
  end

  #invia un invito ad iscriversi al gruppo
  def invite(group_invitation_id)
    @group_invitation = GroupInvitation.find(group_invitation_id)
    @group_invitation_email = @group_invitation.group_invitation_email
    @group = @group_invitation_email.group
    mail(:to => @group_invitation_email.email, :subject => "Invito ad iscriversi a #{@group.name}")
  end

end

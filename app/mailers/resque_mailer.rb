#encoding: utf-8
class ResqueMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "Airesis <info@airesis.it>"

  layout 'maktoub/newsletter_mailer'

  #specific templates for notification types
  TEMPLATES = { 5 => 'new_contribute', 1 => 'new_contribute', 2 => 'text_update', 25 => 'unintegrated_contribute'}
  
  def notification(alert_id)
    @alert = UserAlert.find(alert_id)
    @data = @alert.notification.data
    to_id = @data['to_id']
    subject_id = @data['subject']
    subject = subject_id || @alert.notification.notification_type.email_subject
    template_name = TEMPLATES[@alert.notification.notification_type_id] || 'notification'
    if to_id
      mail(:to => "discussion+#{to_id}@airesis.it", :bcc => @alert.user.email, :subject => subject, :template_name => template_name)
    else
      mail(:to => @alert.user.email, :subject => subject, :template_name => template_name)
    end
  end
  
  def admin_message(msg)
    @msg = msg
    mail(:to => 'coorasse+daily@gmail.com', :subject => APP_SHORT_NAME + " - Messaggio di amministrazione")
  end

  def report_message(report_id)
    @report = ProposalCommentReport.find(report_id)

    mail(:to => 'coorasse+report@gmail.com', :subject => APP_SHORT_NAME + " - Segnalazione Contributo")
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

  def user_message(subject,body,from_id,to_id)
    @body = body
    @from = User.find(from_id)
    @to = User.find(to_id)
    mail(to: @to.email, from: "Airesis <noreply@airesis.it>", reply_to: @from.email, subject: subject)
  end


  def publish(params)
    user = User.find_by_id(params['user_id'])
    mail_fields = {
      subject: params['subject'],
      to: user.email
    }
    @name = user.fullname

    mail(mail_fields) do |format|
      format.html { render("maktoub/newsletters/#{params['newsletter']}") }
    end
  end

  def feedback(feedback_id)
    @feedback = SentFeedback.find(feedback_id)
    @feedback.email ?
    mail(to: 'info@airesis.it', from: "Feedback <feedback@airesis.it>", reply_to: @feedback.email, subject: 'Nuova segnalazione') :
    mail(to: 'info@airesis.it', from: "Feedback <feedback@airesis.it>", subject: 'Nuova segnalazione')
  end
end

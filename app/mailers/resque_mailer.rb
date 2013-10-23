#encoding: utf-8
class ResqueMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "Airesis <info@airesis.it>"

  layout :choose_layout

  #specific templates for notification types
  TEMPLATES = { 5 => 'new_contribute', 1 => 'new_contribute', 2 => 'text_update', NotificationType::UNINTEGRATED_CONTRIBUTE => 'unintegrated_contribute', NotificationType::NEW_BLOG_COMMENT => 'new_blog_comment'}
  
  def notification(alert_id)
    @alert = UserAlert.find(alert_id)
    I18n.locale = @alert.user.locale.key || 'it'
    @data = @alert.notification.data
    to_id = @data[:to_id]
    subject_id = @data[:subject]
    subject = @alert.email_subject
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
    I18n.locale = @group_invitation.inviter.locale.key
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

  def massive_email(from_id,to_ids,group_id,subject,body)
    @body = body
    @from = User.find(from_id)
    @group = Group.find(group_id)
    @to = @group.partecipants.where('users.id in (?)',to_ids.split(','))
    mail(bcc: @to.map{|u| u.email}, from: "Airesis <noreply@airesis.it>", reply_to: @from.email, to: "test@airesis.it", subject: subject)
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
    mail(to: 'help@airesis.it', from: @feedback.email, subject: "#{l Time.now} - Nuova segnalazione ") : #todo extract this email address
    mail(to: 'help@airesis.it', from: "Feedback <feedback@airesis.it>", subject: "#{l Time.now} - Nuova segnalazione")  #todo extract this email address
  end

  def blocked(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, from: "Airesis <noreply@airesis.it>", subject: 'Cancellazione account')
  end

  def topic_reply(post_id, subscriber_id)
    # only pass id to make it easier to send emails using resque
    @post = Frm::Post.find(post_id)
    @group = @post.forum.group
    @user = User.find(subscriber_id)
    mail(from: "Airesis Forum <replytest+#{@post.token}@airesis.it>", :to => @user.email, :subject => "[#{@group.name}] #{@post.topic.subject}")
  end

  protected

  def choose_layout
    (['invite','admin_message','feedback'].include? action_name) ? 'maktoub/unregistered_mailer' : 'maktoub/newsletter_mailer'
  end
end

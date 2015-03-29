#encoding: utf-8
class ResqueMailer < ActionMailer::Base
  helper ProposalsHelper, EmailHelper, GroupsHelper
  default from: ENV['DEFAULT_FROM']

  layout :choose_layout

  #specific templates for notification types
  TEMPLATES = {
      NotificationType::NEW_CONTRIBUTES => 'new_contribute',
      NotificationType::NEW_CONTRIBUTES_MINE => 'new_contribute',
      NotificationType::NEW_COMMENTS_MINE => 'new_contribute',
      NotificationType::NEW_COMMENTS => 'new_contribute',
      NotificationType::TEXT_UPDATE => 'text_update',
      NotificationType::NEW_PUBLIC_PROPOSALS => 'new_proposal',
      NotificationType::NEW_PROPOSALS => 'new_proposal',
      NotificationType::NEW_PUBLIC_EVENTS => 'notifications/new_event',
      NotificationType::NEW_EVENTS => 'notifications/new_event',
      NotificationType::AVAILABLE_AUTHOR => 'notifications/available_author',
      NotificationType::UNINTEGRATED_CONTRIBUTE => 'unintegrated_contribute',
      NotificationType::NEW_BLOG_COMMENT => 'new_blog_comment',
      NotificationType::CONTRIBUTE_UPDATE => 'notifications/update_contribute'
  }

  def notification(alert_id)
    @alert = Alert.find(alert_id)
    return if @alert.checked #do not send emails for already checked alerts
    I18n.locale = @alert.user.locale.key || 'en'
    @data = @alert.notification.data
    to_id = @data[:to_id]
    subject_id = @data[:subject]
    subject = @alert.email_subject
    template_name = TEMPLATES[@alert.notification.notification_type_id] || 'notification'
    if to_id
      mail(to: "discussion+#{to_id}@airesis.it", bcc: @alert.user.email, subject: subject, template_name: template_name) #todo extract email
    else
      mail(to: @alert.user.email, from: ENV['NOREPLY_EMAIL'], subject: subject, template_name: template_name)
    end
  end

  def admin_message(msg)
    @msg = msg
    mail(to: ENV['ADMIN_EMAIL'], subject: ENV['APP_SHORT_NAME'] + " - Messaggio di amministrazione")
  end

  def report_message(report_id)
    @report = ProposalCommentReport.find(report_id)

    mail(to: ENV['ADMIN_EMAIL'], subject: ENV['APP_SHORT_NAME'] + " - Segnalazione Contributo")
  end


  def info_message(msg)
    mail(to: ENV['ADMIN_EMAIL'], subject: ENV['APP_SHORT_NAME'] + " - Messaggio di informazione")
  end

  # send an invite to subscribe in the group
  def invite(group_invitation_email_id)
    @group_invitation_email = GroupInvitationEmail.find(group_invitation_email_id)
    @group_invitation = @group_invitation_email.group_invitation
    @group = @group_invitation.group
    @inviter = @group_invitation.inviter

    I18n.locale = @group_invitation.inviter.locale.key
    mail(to: @group_invitation_email.email, subject: t('mailer.invite.subject', group_name: @group.name))
  end

  def user_message(subject, body, from_id, to_id)
    @body = body
    @from = User.find(from_id)
    @user = User.find(to_id)
    I18n.locale = @user.locale.key || 'en'
    mail(to: @user.email, from: ENV['NOREPLY_EMAIL'], reply_to: @from.email, subject: subject)
  end

  def massive_email(from_id, to_ids, group_id, subject, body)
    @body = body
    @from = User.find(from_id)
    @group = Group.find(group_id)
    @user = @from
    @to = @group.participants.where('users.id in (?)', to_ids.split(','))
    mail(bcc: @to.map { |u| u.email }, from: ENV['NOREPLY_EMAIL'], reply_to: @from.email, to: "test@airesis.it", subject: subject) #todo extract email
  end

  def url_options
    options = {}
    options.merge!(host: @user.locale.host, l: @user.locale.lang) if @user
    options
  end

  def publish(newsletter_id, user_id)
    @user = User.find(user_id)
    @newsletter = Newsletter.find(newsletter_id)
    I18n.locale = @user.locale.key || 'en'

    mail(subject: @newsletter.subject, to: @user.email) do |format|
      format.html { render inline: @newsletter.body, layout: 'newsletters/default' }
    end
  end

  def feedback(feedback_id)
    @feedback = SentFeedback.find(feedback_id)
    to_email = @feedback.email || ENV['FEEDBACK_SENDER']
    mail(to: ENV['FEEDBACK_RECEIVER'], from: to_email, subject: t('feedback_subject', time: (l Time.now)))
  end

  def blocked(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, from: ENV['NOREPLY_EMAIL'], subject: 'Cancellazione account')
  end

  def topic_reply(post_id, subscriber_id)
    # only pass id to make it easier to send emails using resque
    @post = Frm::Post.find(post_id)
    @group = @post.forum.group
    @user = User.find(subscriber_id)
    mail(from: "Airesis Forum <replytest+#{@post.token}@airesis.it>", to: @user.email, subject: "[#{@group.name}] #{@post.topic.subject}") #todo extract email
  end


  def test_mail
    mail(to: ENV['ADMIN_EMAIL'], subject: "Test Redis To Go")
  end

  def few_users_a(group_id)
    @group =Group.find(group_id)
    @user = @group.portavoce.first
    mail(to: @user.email, subject: "#{@group.name} non ha ancora dei partecipanti") if @user.email
  end

  protected

  def choose_layout
    (['invite', 'admin_message', 'feedback', 'test'].include? action_name) ? 'maktoub/unregistered_mailer' : (['notification'].include? action_name) ? 'maktoub/notification_mailer' : 'newsletters/default'
  end
end

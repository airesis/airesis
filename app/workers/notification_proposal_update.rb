class NotificationProposalUpdate < NotificationSender

  def send_notification_for_proposal(notification, user)
    return if BlockedProposalAlert.find_by(user: user, proposal: @proposal)
    send_notification_to_user(notification, user)
  end

  # TODO: implement
  def check_destroyable(notification, user)
    destroyable = notification.notification_type.destroyable #list of destroyable notification types
    destroyable.each do |notification_type|
      alert_jobs = search_alert_jobs(notification_type, user)
      alert_jobs.each do |alert_job|
        if alert_job.completed?
          alert_job.alert.soft_delete
          email_job = alert_job.alert.email_job
          email_job.canceled! unless email_job.completed?
        else
          alert_job.canceled!
        end
      end
    end
  end

  def build_alert(notification, user)
    AlertJob.factory(notification, user, @trackable)
  end

  def send_notification_to_user(notification, user)
    return if user.blocked_notifications.include? notification.notification_type #se il tipo non è bloccato
    check_destroyable(notification, user)
    if notification.notification_type.cumulable?
      send_cumulable_alert_to_user(notification, user)
    else # this notification type is not cumulable. just send it
      build_alert(notification, user)
    end
  end

  def send_cumulable_alert_to_user(notification, user)
    alert_job = search_for_cumulable(notification.notification_type, user)
    if alert_job.present? # an alert is already in queue
      alert_job.accumulate(1) #accumulate one notification on the previous one
    else # no alerts in queue
      alert = search_for_unread_alert(user, notification.notification_type)
      if alert # we have an unread alert, already sent
        alert.accumulate(1)
      else # last alert has been already checked. no email will be sent then (or has already been sent)...create a new alert
        build_alert(notification, user)
      end
    end
  end

  def search_for_unread_alert(user, notification_type)
    Alert.joins(:notification).
      find_by(checked: false, user: user, trackable: @trackable, notifications: {notification_type_id: notification_type.id})
  end

  def search_for_cumulable(notification_type, user)
    search_alert_jobs(notification_type, user).where(status: 0).first
  end

  def search_alert_jobs(notification_type, user)
    AlertJob.where(notification_type: notification_type, user: user, trackable: @trackable)
  end

  def perform(current_user_id, proposal_id, group_id = nil)
    set_instance_variables(current_user_id, proposal_id, group_id)
    current_user = User.find(current_user_id)
    notification_a = build_notification_a
    @proposal.participants.each do |user|
      next if user == current_user
      send_notification_for_proposal(notification_a, user)
    end
  end

  def build_notification_a
    data = {proposal_id: @proposal.id.to_s, revision_id: (@proposal.last_revision.try(:id)), title: @proposal.title}
    if @group.present?
      data[:group] = @group.name
      data[:subdomain] = @group.subdomain if @group.certified?
    end
    notification_a = Notification.new(notification_type_id: @notification_type_id,
                                      url: url_for_proposal,
                                      data: data)
    notification_a.save
    notification_a
  end

  def set_instance_variables(current_user_id, proposal_id, group_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    @notification_type_id = NotificationType::TEXT_UPDATE
    @group = group_id ? Group.find(group_id) : nil
  end
end

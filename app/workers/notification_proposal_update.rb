class NotificationProposalUpdate < NotificationSender

  def has_acknowlodged(proposal, user)
    proposal.acked_by?(user)
  end

  def send_notification_for_proposal(notification, user, proposal)
    return if BlockedProposalAlert.find_by(user_id: user.id, proposal_id: proposal.id)
    return if has_acknowlodged(proposal, user)
    send_notification_to_user(notification, user, proposal)
  end

  def send_notification_to_user(notification, user, trackable)
    return if user.blocked_notifications.include? notification.notification_type #se il tipo non è bloccato
    destroyable = notification.notification_type.destroyable #list of destroyable notification types
    destroyable.each do |notification_type|
      alert_jobs = search_alert_jobs(notification_type, user, trackable)
      alert_jobs.each do |alert_job|
        if alert_job.completed?
          alert_job.alert.soft_delete
          email_job = search_email_jobs(alert_job.alert)
          email_job.canceled! unless email_job.completed?
        else
          alert_job.canceled!
        end
      end
    end
    if notification.notification_type.cumulable?
      alert_job = search_for_cumulable(notification.notification_type, user, trackable)
      if alert_job.present? # an alert is already in queue
        alert_job.accumulate(1) #accumulate one notification on the previous one
      else # no alerts in queue
        alert = search_for_unread_alert(user, notification.notification_type, trackable)
        if alert # we have an unread alert, already sent
          alert.increase_count! # increase the count in the alert
          email_job = search_for_cumulable_email(alert)
          if email_job # an email is in queue?
            email_job.accumulate # requeue it on new daly
          else # alert is sent, email is sent, but alert is not read yet, just send a new email for the previous (accumulated) alert
            alert.send_email(true)
          end
        else # last alert has been already checked. no email will be sent then (or has already been sent)...create a new alert
          AlertJob.factory(notification, user, trackable)
        end
      end
    else # this notification type is not cumulable. just send it
      AlertJob.factory(notification, user, trackable)
    end
  end

  def search_for_unread_alert(user, notification_type, trackable)
    Alert.joins(:notification).
      find_by(checked: false, user: user, trackable: trackable, notifications: {notification_type_id: notification_type.id})
  end

  def search_for_cumulable_email(alert)
    EmailJob.find_by(alert_id: alert.id, status: 0)
  end


  def search_for_cumulable(notification_type, user, trackable)
    AlertJob.find_by(notification_type: notification_type, user: user, trackable: trackable, status: 0)
  end

  def search_for_destroy(notification_type, user, trackable)
    AlertJob.where(notification_type: notification_type, user: user, trackable: trackable, status: 0)
  end

  def search_alert_jobs(notification_type, user, trackable)
    AlertJob.where(notification_type: notification_type, user: user, trackable: trackable)
  end

  def search_email_jobs(alert)
    EmailJob.find_by(alert_id: alert.id)
  end

  def perform(current_user_id, proposal_id, group_id = nil)
    proposal = Proposal.find(proposal_id)
    current_user = User.find(current_user_id) if current_user_id
    group = Group.find(group_id) if group_id
    host = current_user.locale.host
    data = {'proposal_id' => proposal.id.to_s, 'revision_id' => (proposal.last_revision.try(:id)), 'title' => proposal.title}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::TEXT_UPDATE, url: url_for_proposal(proposal, group), data: data)
    notification_a.save
    proposal.participants.each do |user|
      next if user == current_user
      send_notification_for_proposal(notification_a, user, proposal)
    end
  end
end

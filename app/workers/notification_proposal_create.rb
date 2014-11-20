class NotificationProposalCreate < NotificationSender

  def perform(proposal_id)
    elaborate(proposal_id)
  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(proposal_id)
    proposal = Proposal.find(proposal_id)
    current_user = proposal.users.first
    group = proposal.group
    group_area = proposal.group_area
    data = {'proposal_id' => proposal.id.to_s, 'proposal' => proposal.title, 'i18n' => 't'}
    host = current_user.locale.host #TODO non è corretto. l'host dovrebbe essere quello di chi riceve la mail ma allora dobbiamo spostare l'url nell'alert. da fare nella 4.0
    if group #if it's a group proposal
      data['group_id'] = group.id.to_s
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?

      if group_area
        data['group_area_id'] = group_area.id.to_s
        data['group_area'] = group_area.name
        receivers = group_area.scoped_participants(GroupAction::PROPOSAL_VIEW)
      else
        receivers = group.scoped_participants(GroupAction::PROPOSAL_VIEW)
      end
      notification_a = Notification.new(notification_type_id: NotificationType::NEW_PROPOSALS, url: group_proposal_url(group, proposal, host: host), data: data)
      notification_a.save
      receivers.each do |user|
        if user != current_user
          send_notification_to_user(notification_a, user)
        end
      end
    else
      #if it'a a public proposal
      notification_a = Notification.new(notification_type_id: NotificationType::NEW_PUBLIC_PROPOSALS, url: proposal_url(proposal, {subdomain: false, host: host}), data: data)
      notification_a.save
      User.where("id not in (#{User.select("users.id").joins(:blocked_alerts).where("blocked_alerts.notification_type_id = ?", NotificationType::NEW_PUBLIC_PROPOSALS).to_sql})").each do |user|
        if user != current_user
          send_notification_to_user(notification_a, user)
        end
      end
    end
  end
end

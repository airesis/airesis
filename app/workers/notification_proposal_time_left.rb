class NotificationProposalTimeLeft < NotificationSender

  def perform(proposal_id,type)
    elaborate(proposal_id,type)
  end

  def elaborate(proposal_id,type)
    proposal = Proposal.find(proposal_id)
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'extension' => type}
    group = proposal.group
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::PHASE_ENDING, url: url_for_proposal(proposal, group), data: data)
    notification_a.save!
    receivers(proposal).each do |user|
      another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
      send_notification_for_proposal(notification_a, user,proposal)
    end
  end

  def receivers(proposal)
    proposal.notification_receivers
  end
end

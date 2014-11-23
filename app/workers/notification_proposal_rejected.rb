class NotificationProposalRejected < NotificationSender

  def perform(proposal_id)
    elaborate(proposal_id)
  end

  #if a proposal is voted and rejected by votation
  #TODO test
  def elaborate(proposal_id)
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    group_area = proposal.group_area

    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'rejected'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal, group), data: data)
    notification_a.save
    proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user,proposal)
    end

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    proposal.participants.each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification_b, user,proposal)
      end
    end

  end
end

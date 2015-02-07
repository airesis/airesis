class NotificationProposalAbandoned < NotificationSender

  def perform(proposal_id, participant_ids = [])
    elaborate(proposal_id, participant_ids)
  end

  #send alerts when a proposal is abandoned
  def elaborate(proposal_id, participant_ids = [])
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'abandoned'}

    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal,group), data: data)
    notification_a.save
    old_authors(proposal).each do |user|
      send_notification_for_proposal(notification_a, user, proposal)
    end

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal,group), data: data)
    old_participants(proposal,participant_ids).each do |user|
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification_b, user, proposal)
    end
  end


  def old_authors(proposal)
    proposal.proposal_lives.first.users
  end

  def old_participants(proposal, participant_ids)
    User.where(id: participant_ids).where.not(id: old_authors(proposal).pluck(:id))
  end
end

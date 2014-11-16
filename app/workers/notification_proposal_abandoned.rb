class NotificationProposalAbandoned < NotificationSender

  def perform(proposal_id, group_id = nil)
    elaborate(proposal_id, group_id)
  end

  #invia le notifiche quando un una proposta viene aggiornata
  def elaborate(proposal_id, group_id = nil)
    proposal = Proposal.find(proposal_id)
    group = Group.find(group_id) if group_id
    subject = ''
    subject += "[#{group.name}] " if group
    subject +="#{proposal.title} non ha superato il dibattito"
    data = {'proposal_id' => proposal.id.to_s, 'subject' => subject, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'abandoned'}

    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal,group), data: data)
    notification_a.save
    proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user, proposal) unless (defined? current_user) && (user == current_user)
    end

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal,group), data: data)
    proposal.participants.each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification_b, user, proposal)
      end
    end
  end
end

class NotificationProposalWaitingForDate < NotificationSender

  def perform(proposal_id,user_id)
    elaborate(proposal_id,user_id)
  end

  #invia le notifiche quando viene scelta una data di votazione per la proposta
  #le notifiche vengono inviate ai creatori e ai partecipanti alla proposta
  def elaborate(proposal_id,user_id)
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    current_user = User.find(user_id)
    nickname = ProposalNickname.find_by(user_id: current_user.id, proposal_id: proposal.id)
    name = proposal.is_anonima? ? nickname.nickname : current_user.fullname
    data = {'proposal_id' => proposal.id.to_s, 'name' => name, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'waiting_date'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal, group), data: data)
    notification_a.save
    proposal.participants.each do |user|
      if user != current_user
        send_notification_for_proposal(notification_a, user, proposal)
      end
    end
  end
end

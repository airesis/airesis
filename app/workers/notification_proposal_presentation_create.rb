class NotificationProposalPresentationCreate < NotificationSender
  #todo aggiungere un campo accepted_by per cpire chi lo ha aggiunto come autore e non inviare la notifica anche a lui
  def perform(proposal_presentation_id)
    elaborate(proposal_presentation_id)
  end

  def elaborate(proposal_presentation_id)
    proposal_presentation = ProposalPresentation.find(proposal_presentation_id)
    proposal = proposal_presentation.proposal
    user = proposal_presentation.user
    data = {'proposal_id' => proposal.id.to_s, 'user_id' => user.id.to_s, 'title' => proposal.title, 'i18n' => 't'}
    notification_a = Notification.new(notification_type_id: NotificationType::AUTHOR_ACCEPTED, url: url_for_proposal(proposal, group), data: data)
    notification_a.save
    send_notification_for_proposal(notification_a, user, proposal)

    nickname = ProposalNickname.find_by(user_id: user.id, proposal_id: proposal.id)
    name = (nickname && proposal.is_anonima?) ? nickname.nickname : user.fullname #send nickname if proposal is anonymous
    data = {'proposal_id' => proposal.id.to_s, 'user_id' => user.id.to_s, 'user' => name, 'title' => proposal.title, 'i18n' => 't'}
    notification_b = Notification.new(notification_type_id: NotificationType::NEW_AUTHORS, url: url_for_proposal(proposal, group), data: data)
    notification_b.save
    proposal.participants.each do |participant|
      unless participant == user #invia la notifica a tutti tranne a chi è stato scelto
        send_notification_for_proposal(notification_b, participant, proposal)
      end
    end
  end
end

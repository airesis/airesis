class NotificationParticipationRequestCreate < NotificationSender

  def perform(group_participation_request_id)
    elaborate(group_participation_request_id)
  end

  #invia una notifica agli utenti che possono accettare membri che l'utente corrente ha effettuato una richiesta di partecipazione al gruppo
  def elaborate(group_participation_request_id)
    group_participation_request = GroupParticipationRequest.find(group_participation_request_id)
    user = group_participation_request.user
    group = group_participation_request.group
    data = {'group_id' => group.id.to_s, 'user' => user.fullname, 'user_id' => user.id, 'group' => group.name, 'i18n' => 't'}
    data['subdomain'] = group.subdomain if group.certified?
    notification_a = Notification.new(notification_type_id: NotificationType::NEW_PARTICIPATION_REQUEST, url: group_url(group), data: data)
    notification_a.save
    group.scoped_participants(GroupAction::REQUEST_ACCEPT).each do |user|
      another_increase_or_do('group_id', group.id, user.id, NotificationType::NEW_PARTICIPATION_REQUEST) do
        send_notification_to_user(notification_a, user)
      end
    end
  end
end

#encoding: utf-8
#TODO questi metodi devono essere eseguiti in background e non vi deve essere attesa lato client perchè siano completati
module NotificationHelper

  #invia una notifica ad un utente.
  #se l'utente ha bloccato il tipo di notifica allora non viene inviata
  #se l'utente ha abilitato anche l'invio via mail allora viene inviata via mail
  def send_notification_to_user(notification, user)
    unless user.blocked_notifications.include? notification.notification_type #se il tipo non è bloccato
      @alert = Alert.new(user_id: user.id, notification_id: notification.id, checked: false)
      @alert.save! #invia la notifica
      res = PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil #todo send specific alert to be included
    end
    true
  end


  #invia le notifiche quando un utente valuta la proposta
  #le notifiche vengono inviate ai creatori e ai partecipanti alla proposta
  def notify_user_evaluated_proposal(proposal_ranking, group)
    proposal = proposal_ranking.proposal
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't'}
    notification_a = Notification.new(notification_type_id: NotificationType::NEW_VALUTATION_MINE, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_a.save
    proposal.users.each do |user|
      if user != proposal_ranking.user
        send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end
    notification_b = Notification.create(notification_type_id: NotificationType::NEW_VALUTATION, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    proposal.participants.each do |user|
      if (user != proposal_ranking.user) && (!proposal.users.include? user)
        send_notification_to_user(notification_b, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end
  end

  def notify_user_unintegrated_contribute(proposal_comment)
    @proposal = proposal_comment.proposal
    @group = @proposal.private ? @proposal.groups.first : nil
    comment_user = proposal_comment.user
    nickname = ProposalNickname.find_by_user_id_and_proposal_id(comment_user.id, @proposal.id)
    name = @proposal.is_anonima? ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous

    data = {'proposal_id' => @proposal.id.to_s, 'comment_id' => proposal_comment.id.to_s, 'username' => name, 'proposal' => @proposal.title, 'i18n' => 't'}
    if @group
      data['group'] = @group.name
      data['subdomain'] = @group.subdomain if @group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::UNINTEGRATED_CONTRIBUTE, url: @group ? group_proposal_url(@group, @proposal) : proposal_url(@proposal), data: data)
    notification_a.save
    @proposal.users.each do |user|
      if user != current_user
        send_notification_to_user(notification_a, user)
      end
    end
  end


  #invia le notifiche quando viene scelta una data di votazione per la proposta
  #le notifiche vengono inviate ai creatori e ai partecipanti alla proposta
  def notify_proposal_waiting_for_date(proposal, group = nil)

    nickname = ProposalNickname.find_by_user_id_and_proposal_id(current_user.id, proposal.id)
    name = proposal.is_anonima? ? nickname.nickname : current_user.fullname
    data = {'proposal_id' => proposal.id.to_s, 'name' => name, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'waiting_date'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_a.save
    proposal.participants.each do |user|
      if user != current_user
        send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end
  end

  #invia le notifiche quando la proposta è pronta per essere messa in votazione
  #le notifiche vengono inviate ai creatori  della proposta
  def notify_proposal_ready_for_vote(proposal, group=nil)
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'wait'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_a.save
    proposal.users.each do |user|
      if !(defined? current_user) || (user != current_user)
        send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end
  end


  #invia le notifihe per dire che la votazione è terminata
  def notify_proposal_voted(proposal, group=nil, group_area=nil)
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'voted'}
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_a.save

    proposal.users.each do |user|
      if !(defined? current_user) || (user != current_user)
        send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end

    notification_b = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_b.save

    users = group ?
        group_area ?
            group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) :
            group.scoped_participants(GroupAction::PROPOSAL_VOTE) :
        proposal.participants

    users.each do |user|
      if !(defined? current_user) || (user != current_user)
        unless proposal.users.include? user
          another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
          send_notification_to_user(notification_b, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
        end
      end
    end


  end

  #invia le notifiche quando la proposta è stata rigettata
  #le notifiche vengono inviate ai partecipanti
  def notify_proposal_rejected(proposal, group=nil)
    subject +="#{proposal.title} è stata respinta"
    data = {'proposal_id' => proposal.id.to_s, 'subject' => subject, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'rejected'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_a.save
    proposal.users.each do |user|
      if !(defined? current_user) || (user != current_user)
        send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    proposal.participants.each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_to_user(notification_b, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
      end
    end
  end

  #invia una notifica agli utenti che possono accettare membri che l'utente corrente ha effettuato una richiesta di partecipazione al gruppo
  def notify_user_asked_for_participation(group)
    data = {'group_id' => group.id.to_s, 'user' => current_user.fullname, 'user_id' => current_user.id, 'group' => group.name, 'i18n' => 't'}
    data['subdomain'] = group.subdomain if group.certified?
    notification_a = Notification.new(notification_type_id: NotificationType::NEW_PARTICIPATION_REQUEST, url: group_url(group), data: data)
    notification_a.save
    group.scoped_participants(GroupAction::REQUEST_ACCEPT).each do |user|
      if user != current_user
        another_increase_or_do('group_id', group.id, user.id, NotificationType::NEW_PARTICIPATION_REQUEST) do
          send_notification_to_user(notification_a, user)
        end
      end
    end
  end


  #invia una notifica ai redattori della proposta che qualcuno si è offerto per redigere la sintesi
  def notify_user_available_authors(proposal)
    data = {'proposal_id' => proposal.id.to_s, 'user' => current_user.fullname, 'user_id' => current_user.id, 'title' => proposal.title, 'i18n' => 't'}
    notification_a = Notification.new(notification_type_id: NotificationType::AVAILABLE_AUTHOR, url: proposal.private ? group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal), data: data)
    notification_a.save
    proposal.users.each do |user|
      if user != current_user
        send_notification_to_user(notification_a, user)
      end
    end
  end

  #invia una notifica all'utente che è stato accettato come redattore di una proposta e a tutti i partecipanti
  def notify_user_choosed_as_author(user, proposal)
    data = {'proposal_id' => proposal.id.to_s, 'user_id' => user.id.to_s, 'title' => proposal.title, 'i18n' => 't'}
    notification_a = Notification.new(notification_type_id: NotificationType::AUTHOR_ACCEPTED, url: proposal.private ? group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal), data: data)
    notification_a.save
    send_notification_to_user(notification_a, user)

    nickname = ProposalNickname.find_by_user_id_and_proposal_id(user.id, proposal.id)
    name = (nickname && proposal.is_anonima?) ? nickname.nickname : user.fullname #send nickname if proposal is anonymous
    data = {'proposal_id' => proposal.id.to_s, 'user_id' => user.id.to_s, 'user' => name, 'title' => proposal.title, 'i18n' => 't'}
    notification_b = Notification.new(notification_type_id: NotificationType::NEW_AUTHORS, url: proposal.private ? group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal), data: data)
    notification_b.save
    proposal.participants.each do |participant|
      unless participant == current_user || participant == user #invia la notifica a tutti tranne a chi è stato scelto e ha chi ha scelto
        send_notification_to_user(notification_b, participant)
      end
    end
  end


  #send an alert to participants that there is a new comment in the event
  def notify_new_event_comment(event_comment)
#    blog_post = blog_comment.blog_post
#    user = blog_comment.user
#    unless blog_post.user == user #don't send a notification to myself
#      data = {'blog_post_id' => blog_post.id.to_s, 'blog_comment_id' => blog_comment.id.to_s, 'subject' => "[#{blog_post.title}] Nuovo commento di #{user.fullname}", 'user' => user.fullname, 'title' => blog_post.title, 'i18n' => 't'}
#      notification_a = Notification.new(notification_type_id: NotificationType::NEW_BLOG_COMMENT, url: blog_blog_post_url(blog_post.blog, blog_post), data: data)
#      notification_a.save
#      send_notification_to_user(notification_a, blog_post.user)
#    end
#TODO
  end


  #send a notification to users which have the possibility to evaluate the proposal that they have only 24 hours to evaluate
  def notify_24_hours_left(proposal)
    time_left(proposal, '24_hours')
  end

  #send a notification to users which have the possibility to evaluate the proposal that they have only 1 hour to evaluate
  def notify_1_hour_left(proposal)
    time_left(proposal, '1_hour')
  end

  #send a notification to users which have the possibility to vote the proposal that they have only 24 hours to vote
  def notify_24_hours_left_to_vote(proposal)
    time_left_vote(proposal, '24_hours_vote')
  end

  #send a notification to users which have the possibility to vote the proposal that they have only 1 hour to vote
  def notify_1_hour_left_to_vote(proposal)
    time_left_vote(proposal, '1_hour_vote')
  end

  protected

  def time_left(proposal, type)
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => type}
    group = proposal.private ? proposal.groups.first : nil
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::PHASE_ENDING, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_a.save!
    proposal.notification_receivers.each do |user|
      another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
      send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
    end
  end


  def time_left_vote(proposal, type)
    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => type}
    group = proposal.private ? proposal.groups.first : nil
    group_area = proposal.private ? proposal.presentation_areas.first : nil
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end


    notification_b = Notification.new(notification_type_id: NotificationType::PHASE_ENDING, url: group ? group_proposal_url(group, proposal) : proposal_url(proposal), data: data)
    notification_b.save!

    users = group ?
        group_area ?
            group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) :
            group.scoped_participants(GroupAction::PROPOSAL_VOTE) :
        proposal.participants

    users.each do |user|
      if !(defined? current_user) || (user != current_user)
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_to_user(notification_b, user) unless (BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id) || proposal.user_votes.find_by_user_id(user.id)) #don't send if he has already voted
      end
    end
  end


  #delete previous notifications
  def another_delete(attribute, attr_id, user_id, notification_type)
    another = Alert.another(attribute, attr_id, user_id, notification_type)
    another.soft_delete_all
  end

  #increase previous notification
  def another_increase_or_do(attribute, attr_id, user_id, notification_type, &block)
    another = Alert.another_unread(attribute, attr_id, user_id, notification_type).first
    if another
      another.increase_count!
      PrivatePub.publish_to("/notifications/#{user_id}", pull: 'hello') rescue nil #todo send specific alert to be included
    else
      block.call
    end
  end

end

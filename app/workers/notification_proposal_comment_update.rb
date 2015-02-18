class NotificationProposalCommentUpdate < NotificationSender

  def perform(comment_id)
    elaborate(comment_id)
  end

  #invia le notifiche quando un un contributo viene aggiornato
  def elaborate(comment_id)
    comment = ProposalComment.find(comment_id)
    proposal = comment.proposal
    comment_user = comment.user
    rankers = comment.rankers.where("users.id != #{comment.user_id}")

    return if rankers.empty?
    return unless comment.is_contribute?

    host = comment_user.locale.host
    nickname = ProposalNickname.find_by_user_id_and_proposal_id(comment_user.id, proposal.id)
    name = (nickname && proposal.is_anonima?) ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous
    url = nil

    data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'username' => name, 'name' => name, 'title' => proposal.title}
    query = {'comment_id' => comment.id.to_s}
    if proposal.private?
      group = proposal.groups.first
      url = group_proposal_url(group, proposal, {host: host})
      data['group'] = group.name
      data['group_id'] = group.id
      data['subdomain'] = group.subdomain if group.certified?
    else
      url = proposal_url(proposal, {host: host})
    end
    if comment.paragraph
      query['paragraph_id'] = data['paragraph_id'] = comment.paragraph_id
      query['section_id'] = data['section_id'] = comment.paragraph.section_id
    end


    notification_a = Notification.new(notification_type_id: NotificationType::CONTRIBUTE_UPDATE, url: url +"?#{query.to_query}", data: data)
    notification_a.save
    rankers.each do |user|
      send_notification_for_proposal(notification_a, user, proposal)
    end
  end
end

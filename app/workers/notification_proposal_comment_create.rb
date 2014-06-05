class NotificationProposalCommentCreate < NotificationSender
  include Sidekiq::Worker, GroupsHelper, Rails.application.routes.url_helpers

  def perform(comment_id)
    elaborate(comment_id)
  end

  #invia le notifiche quando un un contributo viene creato
  def elaborate(comment_id)
    comment = ProposalComment.find(comment_id)
    proposal = comment.proposal
    comment_user = comment.user
    nickname = ProposalNickname.find_by_user_id_and_proposal_id(comment_user.id, proposal.id)
    name = (nickname && proposal.is_anonima?) ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous
    host = comment_user.locale.host
    url = nil

    data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'username' => name, 'name' => name, 'title' => proposal.title, 'i18n' => 't', 'count' => 1}
    query = {'comment_id' => comment.id.to_s}
    if proposal.private?
      group = proposal.presentation_groups.first
      url = group_proposal_url(group,proposal,{host: host})
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    else
      url = proposal_url(proposal,{host: host})
    end
    if comment.paragraph
      query['paragraph_id'] = data['paragraph_id'] = comment.paragraph_id
      query['section_id'] = data['section_id'] = comment.paragraph.section_id

    end

    if comment.is_contribute?
      proposal.users.each do |user|   #send emails to editors
        if user != comment_user
          #check if there is another alert to this user about new contributes that he has not read yet
          another_increase_or_do('proposal_id',proposal.id,user.id,NotificationType::NEW_CONTRIBUTES_MINE) do
            #for contributes we create a notification for each user and aggregate them if needed
            notification_a = Notification.create!(notification_type_id: NotificationType::NEW_CONTRIBUTES_MINE, url: url + "?#{query.to_query}",data: data)
            send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          end
        end
      end


      proposal.participants.each do |user|
        if (user != comment_user) && (!proposal.users.include? user)
          another_increase_or_do('proposal_id',proposal.id,user.id,NotificationType::NEW_CONTRIBUTES) do
            notification_b = Notification.create!(notification_type_id: NotificationType::NEW_CONTRIBUTES, url: url +"?#{query.to_query}", data: data)
            #for contributes we create a notification for each user and aggregate them if needed
            send_notification_to_user(notification_b, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          end
        end
      end
    else
      data[:parent_id] = comment.contribute.id

      notification_a = Notification.new(notification_type_id: NotificationType::NEW_COMMENTS, url: url +"?#{query.to_query}", data: data)
      notification_a.save

      comment.contribute.participants.each do |user|
        unless user == comment_user
          another_increase_or_do('parent_id',comment.contribute.id,user.id,NotificationType::NEW_COMMENTS) do
            send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          end
        end
      end
    end
  end
end
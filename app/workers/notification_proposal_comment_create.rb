class NotificationProposalCommentCreate < NotificationSender
  include GroupsHelper, Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(comment_id)
    NotificationProposalCommentCreate.new.elaborate(comment_id)
  end

  #invia le notifiche quando un un contributo viene creato
  def elaborate(comment_id)
    comment = ProposalComment.find(comment_id)
    proposal = comment.proposal
    comment_user = comment.user
    nickname = ProposalNickname.find_by_user_id_and_proposal_id(comment_user.id, proposal.id)
    name = (nickname && proposal.is_anonima?) ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous
    url = nil

    data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'username' => name, 'name' => name, 'title' => proposal.title, 'i18n' => 't', 'count' => 1}
    query = {'comment_id' => comment.id.to_s}
    if proposal.private?
      group = proposal.presentation_groups.first
      url = group_proposal_url(group,proposal)
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    else
      url = proposal_url(proposal)
    end
    if comment.paragraph
      query['paragraph_id'] = data['paragraph_id'] = comment.paragraph_id
      query['section_id'] = data['section_id'] = comment.paragraph.section_id

    end

    if comment.is_contribute?
      proposal.users.each do |user|   #send emails to editors
        if user != comment_user
          #check if there is another alert to this user about new contributes that he has not read yet
          another = UserAlert.another('proposal_id',proposal.id,user.id,NotificationType::NEW_CONTRIBUTES_MINE).first
          if another
            another.increase_count!
            PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil  #todo send specific alert to be included
          else
            #for contributes we create a notification for each user and aggregate them if needed
            notification_a = Notification.create!(:notification_type_id => NotificationType::NEW_CONTRIBUTES_MINE, :url => url + "?#{query.to_query}",:data => data)
            send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          end
        end
      end


      proposal.partecipants.each do |user|
        if (user != comment_user) && (!proposal.users.include? user)
          #check if there is another notification to this user about new contributes that he has not read yet
          another = UserAlert.another('proposal_id',proposal.id,user.id,NotificationType::NEW_CONTRIBUTES).first
          if another
            another.increase_count!
            PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil  #todo send specific alert to be included
          else
            notification_b = Notification.create!(:notification_type_id => NotificationType::NEW_CONTRIBUTES, :url => url +"?#{query.to_query}", :data => data)
            #for contributes we create a notification for each user and aggregate them if needed
            send_notification_to_user(notification_b, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          end
        end
      end
    else
      data[:parent_id] = comment.contribute.id

      notification_a = Notification.new(:notification_type_id => NotificationType::NEW_COMMENTS, :url => url +"?#{query.to_query}", :data => data)
      notification_a.save

      comment.contribute.partecipants.each do |user|
        unless user == comment_user
          another = UserAlert.another('parent_id',comment.contribute.id,user.id,NotificationType::NEW_COMMENTS).first
          if another
            another.increase_count!
            PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil  #todo send specific alert to be included
          else
            send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          end
        end
      end
    end
  end
end
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
    host = comment_user.locale.host
    url = nil
    data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'username' => name, 'name' => name, 'title' => proposal.title, 'i18n' => 't'}
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
      notification_a = Notification.new(:notification_type_id => NotificationType::NEW_CONTRIBUTES_MINE, :url => url +"?#{query.to_query}", :data => data)
      notification_a.save
      proposal.users.each do |user|
        if user != comment_user
          #TODO undo because the notification link point to a specific contribute right know
          #check if there is another notification to this user about new contributes that he has not read yet
          #another = Notification.first(:joins => [:notification_data, :user_alerts => [:user]], :conditions => ['notification_data.name = ? and notification_data.value = ? and notifications.notification_type_id = ? and users.id = ? and user_alerts.checked = false', 'proposal_id', proposal.id.to_s, NotificationType::NEW_CONTRIBUTES_MINE, user.id.to_s], readonly: false)
          #if another
          #  count_data = another.notification_data.find_or_create_by_name('count').update_attribute(:value,another.data[:count].to_i + 1)
          #  another.save!
          #else
            #for contributes we create a notification for each user and aggregate them if needed
          #  notification_a = Notification.new(:notification_type_id => NotificationType::NEW_CONTRIBUTES_MINE, :url => @url + "?#{query.to_query}",:data => data)
          #  notification_a.save!
          #  send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
          #end
          send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
        end
      end
      notification_b = Notification.create(:notification_type_id => NotificationType::NEW_CONTRIBUTES, :url => url +"#comment"+comment.id.to_s, :data => data)
      proposal.partecipants.each do |user|
        if (user != comment_user) && (!proposal.users.include? user)
          send_notification_to_user(notification_b, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
        end
      end
    else
      notification_a = Notification.new(:notification_type_id => NotificationType::NEW_COMMENTS, :url => url +"?#{query.to_query}", :data => data)
      notification_a.save

      comment.contribute.partecipants.each do |user|
        unless user == comment_user
          send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
        end
      end
    end
  end
end
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
    if proposal.private?
      group = proposal.presentation_groups.first
      url = group_proposal_url(group,proposal)
    else
      url = proposal_url(proposal)
    end
    if comment.is_contribute?
      subject = proposal.private? ? "[#{group.name}]" : ''
      subject += " #{proposal.title} - Nuovo contributo"
      data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'subject' => subject, 'username' => name, 'name' => name, 'title' => proposal.title, 'group' => group.name, 'i18n' => 't'}
      query = {'comment_id' => comment.id.to_s}
      if comment.paragraph
        query['paragraph_id'] = data['paragraph_id'] = comment.paragraph_id
        query['section_id'] = data['section_id'] = comment.paragraph.section_id

      end
      notification_a = Notification.new(:notification_type_id => NotificationType::NEW_CONTRIBUTES_MINE, :url => url +"?#{query.to_query}", :data => data)
      notification_a.save
      proposal.users.each do |user|
        if user != comment_user
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
      subject = proposal.private? ? "[#{proposal.presentation_groups.first.name}]" : ''
      subject += " #{proposal.title} - Nuovo commento"
      data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'subject' => subject, 'username' => name, 'name' => name, 'title' => proposal.title, 'i18n' => 't'}
      query = {'comment_id' => comment.id.to_s}
      if comment.paragraph
        query['paragraph_id'] = data['paragraph_id'] = comment.paragraph_id
        query['section_id'] = data['section_id'] = comment.paragraph.section_id
      end
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
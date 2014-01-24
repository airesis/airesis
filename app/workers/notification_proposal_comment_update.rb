class NotificationProposalCommentUpdate < NotificationSender
  include GroupsHelper, Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(comment_id)
    NotificationProposalCommentUpdate.new.elaborate(comment_id)
  end

  #invia le notifiche quando un un contributo viene aggiornato
  def elaborate(comment_id)
    comment = ProposalComment.find(comment_id)
    proposal = comment.proposal
    comment_user = comment.user

    rankers = comment.rankers.where("users.id != #{comment.user_id}")

    if rankers.size > 0
      nickname = ProposalNickname.find_by_user_id_and_proposal_id(comment_user.id, proposal.id)
      name = (nickname && proposal.is_anonima?) ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous
      url = nil

      data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'username' => name, 'name' => name, 'title' => proposal.title, 'i18n' => 't'}
      query = {'comment_id' => comment.id.to_s}
      if proposal.private?
        group = proposal.presentation_groups.first
        url = group_proposal_url(group, proposal)
        data['group'] = group.name
        data['group_id'] = group.id
        data['subdomain'] = group.subdomain if group.certified?
      else
        url = proposal_url(proposal)
      end
      if comment.paragraph
        query['paragraph_id'] = data['paragraph_id'] = comment.paragraph_id
        query['section_id'] = data['section_id'] = comment.paragraph.section_id

      end

      if comment.is_contribute?
        notification_a = Notification.new(:notification_type_id => NotificationType::CONTRIBUTE_UPDATE, :url => url +"?#{query.to_query}", :data => data)
        notification_a.save
        rankers.each do |user|
          send_notification_to_user(notification_a, user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id)
        end
      end
    end
  end
end
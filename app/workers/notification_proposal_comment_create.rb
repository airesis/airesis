class NotificationProposalCommentCreate < NotificationSender
  include Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(comment_id)
    NotificationProposalCommentCreate.new.elaborate(comment_id)
  end

  #invia le notifiche quando un un contributo viene creato
  def elaborate(comment_id)
      comment = ProposalComment.find(comment_id)
      proposal = comment.proposal
      comment_user = comment.user
      nickname = ProposalNickname.find_by_user_id_and_proposal_id(comment_user.id,proposal.id)
      name = (nickname && proposal.is_anonima?) ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous

      if comment.is_contribute?
        msg = "<b>"+name+"</b> ha inserito un contributo alla tua proposta <b>"+proposal.title+"</b>!";
        subject = proposal.private? ? "[#{proposal.presentation_groups.first.name}]" : ''
        subject +=  " #{proposal.title} - Nuovo contributo"
        data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'subject' => subject, 'username' => name}
        notification_a = Notification.new(:notification_type_id => NotificationType::NEW_CONTRIBUTES_MINE,:message => msg, :url => proposal_path(proposal) +"#comment"+comment.id.to_s, :data => data)
        notification_a.save
        proposal.users.each do |user|
          if user != comment_user
            send_notification_to_user(notification_a,user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id,proposal.id)
          end
        end

        msg = "<b>"+name+"</b> ha inserito un contributo alla proposta <b>"+proposal.title+"</b>!";
        notification_b = Notification.create(:notification_type_id => NotificationType::NEW_CONTRIBUTES,:message => msg,:url => proposal_url(proposal) +"#comment"+comment.id.to_s, :data => data)
        proposal.partecipants.each do |user|
          if (user != comment_user) && (!proposal.users.include?user)
            send_notification_to_user(notification_b,user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id,proposal.id)
          end
        end
      else
        msg = "<b>"+name+"</b> ha inserito un commento in una discussione nella proposta <b>"+proposal.title+"</b>!";
        subject = proposal.private? ? "[#{proposal.presentation_groups.first.name}]" : ''
        subject +=  " #{proposal.title} - Nuovo commento"
        data = {'comment_id' => comment.id.to_s, 'proposal_id' => proposal.id.to_s, 'to_id' => "proposal_c_#{proposal.id}", 'subject' => subject, 'username' => name}
        notification_a = Notification.new(:notification_type_id => NotificationType::NEW_CONTRIBUTES,:message => msg, :url => proposal_url(proposal) +"#comment"+comment.id.to_s, :data => data)
        notification_a.save

        comment.contribute.partecipants.each do |user|
          if (user != comment_user)
            send_notification_to_user(notification_a,user) unless BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id,proposal.id)
          end
        end
      end
  end
end
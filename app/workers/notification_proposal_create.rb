class NotificationProposalCreate < NotificationSender
  include GroupsHelper, Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(current_user_id,proposal_id,group_id = nil)
    NotificationProposalCreate.new.elaborate(current_user_id,proposal_id,group_id)

  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(current_user_id,proposal_id,group_id = nil)
    proposal = Proposal.find(proposal_id)
    current_user = User.find(current_user_id)
    if group_id
      #if it's a group proposal
      group = Group.find(group_id)
      subject =  "[#{group.name}] #{proposal.title}"
      msg = "E' stata creata una proposta <b>" + proposal.title + "</b> nel gruppo <b>" + group.name + "</b>"
      data = {'group_id' => group.id.to_s, 'proposal_id' => proposal.id.to_s, 'subject' => subject}
      notification_a = Notification.new(:notification_type_id => 10,:message => msg, :url => group_proposal_url(group,proposal,{subdomain: group.certified ? group.subdomain : nil}), :data => data)
      notification_a.save
      #le notifiche vengono inviate ai partecipanti al gruppo che possono visualizzare le proposte
      group.scoped_partecipants(GroupAction::PROPOSAL_VIEW).each do |user|
        if user != current_user
          send_notification_to_user(notification_a,user)
        end
      end
    else
      #if it'a a public proposal
      subject =  "#{proposal.title}"
      msg = "E' stata creata una proposta <b>" + proposal.title + "</b> nello spazio comune"
      data = {'proposal_id' => proposal.id.to_s, 'subject' => subject}
      notification_a = Notification.new(:notification_type_id => 3,:message => msg, :url => proposal_url(proposal,subdomain: false), :data => data)
      notification_a.save
      User.where("id not in (#{User.select("users.id").joins(:blocked_alerts).where("blocked_alerts.notification_type_id = 3").to_sql})").each do |user|
        if user != current_user
          send_notification_to_user(notification_a,user)
        end
      end
    end
  end
end
class NotificationProposalCreate < NotificationSender
  include GroupsHelper, Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(current_user_id,proposal_id,group_id = nil,group_area_id=nil)
    NotificationProposalCreate.new.elaborate(current_user_id,proposal_id,group_id,group_area_id)

  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(current_user_id,proposal_id,group_id = nil,group_area_id=nil)
    proposal = Proposal.find(proposal_id)
    current_user = User.find(current_user_id)
    data = {'proposal_id' => proposal.id.to_s, 'proposal' => proposal.title, 'i18n' => 't'}
    if group_id
      #if it's a group proposal
      group = Group.find(group_id)
      data['group_id'] = group.id.to_s
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?

      #le notifiche vengono inviate ai partecipanti al gruppo che possono visualizzare le proposte
      if group_area_id
        group_area = group.group_areas.find(group_area_id)
        data['group_area_id'] = group_area.id.to_s
        data['group_area'] = group_area.name
        receivers = group_area.scoped_partecipants(GroupAction::PROPOSAL_VIEW)
      else
        receivers = group.scoped_partecipants(GroupAction::PROPOSAL_VIEW)
      end
      notification_a = Notification.new(:notification_type_id => NotificationType::NEW_PROPOSALS, :url => group_proposal_url(group,proposal), :data => data)
      notification_a.save
      receivers.each do |user|
        if user != current_user
          send_notification_to_user(notification_a,user)
        end
      end

    else
      #if it'a a public proposal
      notification_a = Notification.new(:notification_type_id => NotificationType::NEW_PUBLIC_PROPOSALS, :url => proposal_url(proposal,subdomain: false), :data => data)
      notification_a.save
      User.where("id not in (#{User.select("users.id").joins(:blocked_alerts).where("blocked_alerts.notification_type_id = 3").to_sql})").each do |user|
        if user != current_user
          send_notification_to_user(notification_a,user)
        end
      end
    end
  end
end
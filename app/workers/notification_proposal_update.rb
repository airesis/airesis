class NotificationProposalUpdate < NotificationSender

  def perform(current_user_id, proposal_id, group_id = nil)
    set_instance_variables(current_user_id, proposal_id, group_id)
    notification_a = build_notification_a
    @proposal.participants.each do |user|
      next if user == @current_user
      send_notification_for_proposal(notification_a, user)
    end
  end

  def build_notification_a
    data = {proposal_id: @proposal.id,
            user_id: @current_user.id,
            revision_id: (@proposal.proposal_revisions.last.id),
            title: @proposal.title}
    if @group.present?
      data[:group] = @group.name
      data[:subdomain] = @group.subdomain if @group.certified?
    end
    Notification.create(notification_type_id: @notification_type_id,
                                      url: url_for_proposal,
                                      data: data)
  end

  def set_instance_variables(current_user_id, proposal_id, group_id)
    @current_user = User.find(current_user_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    @notification_type_id = NotificationType::TEXT_UPDATE
    @group = group_id ? Group.find(group_id) : nil
  end
end

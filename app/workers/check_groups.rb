class CheckGroups
  include Sidekiq::Worker, GroupsHelper, Rails.application.routes.url_helpers, ProposalsHelper
  sidekiq_options queue: :low_priority

  def perform(*_args)
    Group.joins(:participants).
      where(status: 'active', certified: false).
      where(['groups.created_at < ?', 7.days.ago]).
      group('groups.id').
      having('count(users.*) < 2').readonly(false).each do |group|
      ResqueMailer.few_users_a(group.id).deliver_later
      group.update_attribute(:status, Group::STATUS_FEW_USERS_A)
      group.update_attribute(:status_changed_at, Time.now)
    end
  end
end

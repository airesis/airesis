class DeleteOldNotifications
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(1) }
  sidekiq_options queue: :low_priority

  def perform(*_args)
    count = 0
    deleted = Notification.destroy_all(['created_at < ?', 6.months.ago])
    count += deleted.count
    read = Notification.destroy_all(["notifications.id not in (
                                              select n.id
                                              from notifications n
                                              join alerts ua
                                              on n.id = ua.notification_id
                                              where ua.checked = FALSE)
                                              and created_at < ?", 1.month.ago])
    count += read.count
    count
  end
end

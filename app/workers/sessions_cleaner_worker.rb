# this worker clear all the expired sessions from database.
class SessionsCleanerWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }
  sidekiq_options queue: :low_priority

  def perform(attributes)
    ActiveRecord::SessionStore::Session.delete_all(['updated_at < ?', SESSION_DAYS.days.ago])
  end
end

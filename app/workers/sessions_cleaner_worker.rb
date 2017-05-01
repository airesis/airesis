# this worker clear all the expired sessions from database.
class SessionsCleanerWorker
  def perform
    ActiveRecord::SessionStore::Session.delete_all(['updated_at < ?', SESSION_DAYS.days.ago])
  end
end

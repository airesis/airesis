# this worker clear all the expired sessions from database.
class SessionsCleanerWorker
  def perform
    ActiveRecord::SessionStore::Session.where('updated_at < ?', SESSION_DAYS.days.ago).delete_all
  end
end

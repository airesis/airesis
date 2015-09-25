# worker to create alerts
class AlertsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority, retry: 1

  def perform(attributes)
    Alert.create(attributes.merge(jid: jid))
  end
end

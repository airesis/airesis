module Frm
  class Subscription < FrmTable
    belongs_to :topic
    belongs_to :subscriber, class_name: 'User'

    validates :subscriber_id, presence: true

    def send_notification(post_id)
      ResqueMailer.topic_reply(post_id, subscriber.id).deliver_later if subscriber.present?
    end
  end
end

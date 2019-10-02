module Frm
  class Post < FrmTable
    include Workflow

    workflow_column :state
    workflow do
      state :pending_review do
        event :spam, transitions_to: :spam
        event :approve, transitions_to: :approved
      end
      state :spam
      state :approved do
        event :approve, transitions_to: :approved
      end
    end

    # Used in the moderation tools partial
    attr_accessor :moderation_option

    belongs_to :topic, inverse_of: :posts
    belongs_to :user, class_name: 'User'
    belongs_to :reply_to, class_name: 'Post', optional: true

    has_many :replies, class_name: 'Post',
                       foreign_key: 'reply_to_id',
                       dependent: :nullify

    validates :text, presence: true, length: { maximum: 1.megabyte }

    delegate :forum, to: :topic

    delegate :group, to: :forum

    after_create :set_topic_last_post_at
    after_create :subscribe_replier
    after_create :skip_pending_review

    before_create :populate_token

    after_save :approve_user, if: :approved?
    after_save :blacklist_user, if: :spam?
    after_save :email_topic_subscribers, if: proc { |p| p.approved? && !p.notified? }

    class << self
      def approved
        where(state: 'approved')
      end

      def approved_or_pending_review_for(user)
        if user
          where arel_table[:state].eq('approved').or(
            arel_table[:state].eq('pending_review').and(arel_table[:user_id].eq(user.id))
          )
        else
          approved
        end
      end

      def by_created_at
        order :created_at
      end

      def pending_review
        where state: 'pending_review'
      end

      def spam
        where state: 'spam'
      end

      def visible(user = nil)
        if user
          joins(:topic).where('frm_topics.hidden = false or frm_topics.user_id = ?', user.id)
        else
          joins(:topic).where(frm_topics: { hidden: false })
        end
      end

      def topic_not_pending_review
        joins(:topic).where(frm_topics: { state: 'approved' })
      end

      def moderate!(posts)
        posts.each do |post_id, moderation|
          # We use find_by_id here just in case a post has been deleted.
          post = Post.find_by_id(post_id)
          post.send("#{moderation[:moderation_option]}!") if post
        end
      end
    end

    def user_auto_subscribe?
      user.present?
    end

    def owner_or_admin?(other_user)
      user == other_user || other_user.forem_admin?(group)
    end

    def owner_or_moderator?(other_user)
      user == other_user || other_user.can_moderate_forem_forum?(forum) || other_user.forem_admin?(group)
    end

    # returns the number of his page in case of pagination on the topic
    def page
      ids = topic.posts.pluck(:id)
      position = ids.index(id)
      (position.to_f / TOPICS_PER_PAGE).ceil
    end

    protected

    def subscribe_replier
      topic.subscribe_user(user.id) if topic && user
    end

    def email_topic_subscribers
      topic.subscriptions.includes(:subscriber).find_each do |subscription|
        subscription.send_notification(id) if subscription.subscriber != user
      end
      update_attribute(:notified, true)
    end

    def set_topic_last_post_at
      topic.update_attribute(:last_post_at, created_at)
    end

    def skip_pending_review
      approve!
    end

    def populate_token
      self.token = loop do
        random_token = SecureRandom.urlsafe_base64(16, false)
        break random_token unless Post.where(token: random_token).exists?
      end
    end

    def approve_user
      # TODO: disattivato user.update_attribute(:forem_state, "approved") if user && user.forem_state != "approved"
    end

    def blacklist_user
      user.update_attribute(:forem_state, 'spam') if user
    end
  end
end

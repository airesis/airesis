module Frm
  class Forum < Frm::FrmTable
    include Frm::Concerns::Viewable, ::Concerns::Taggable

    extend FriendlyId
    friendly_id :name, use: :scoped, scope: :group

    belongs_to :category, class_name: 'Frm::Category'

    belongs_to :group, class_name: '::Group', foreign_key: 'group_id'

    has_many :topics, class_name: 'Frm::Topic', dependent: :destroy
    has_many :posts, class_name: 'Frm::Post', through: :topics, dependent: :destroy
    has_many :moderator_groups
    has_many :mods, through: :moderator_groups, source: :frm_mod, class_name: 'Frm::Mod'

    has_many :forum_tags, dependent: :destroy, foreign_key: 'frm_forum_id'
    has_many :tags, through: :forum_tags, class_name: 'Tag'

    validates :category_id, presence: true
    validates :name, presence: true
    validates :description, presence: true

    validate :visibility

    alias_attribute :title, :name

    def last_post_for(forem_user)
      if forem_user && (forem_user.forem_admin?(group) || moderator?(forem_user))
        posts.last
      else
        last_visible_post(forem_user)
      end
    end

    def last_visible_post(forem_user)
      posts.approved_or_pending_review_for(forem_user).last
    end

    def moderator?(user)
      user && (user.frm_mod_ids & mod_ids).any?
    end

    def to_s
      name
    end

    def should_generate_new_friendly_id?
      name_changed?
    end

    protected

    def visibility
      errors.add(:visible_outside, I18n.t('activerecord.errors.messages.forum_visibility')) if visible_outside && !category.visible_outside
    end
  end
end

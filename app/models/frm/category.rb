module Frm
  class Category < Frm::FrmTable
    include Taggable
    extend FriendlyId
    friendly_id :name, use: :scoped, scope: :group

    has_many :forums, -> { order(name: :asc) }
    belongs_to :group, class_name: '::Group', foreign_key: :group_id

    has_many :category_tags, dependent: :destroy, foreign_key: 'frm_category_id'
    has_many :tags, through: :category_tags, class_name: 'Tag'

    validates :name, presence: true

    validate :visibility

    def to_s
      name
    end

    def should_generate_new_friendly_id?
      name_changed?
    end

    protected

    def visibility
      errors.add(:visible_outside, 'Impossibile rendere la sezione privata. Contiene forum pubblici') if !visible_outside && forums.where(visible_outside: true).exists?
    end
  end
end

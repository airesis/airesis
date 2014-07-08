module Frm
  class Category < Frm::FrmTable
    include ::Concerns::Taggable
    extend FriendlyId
    friendly_id :name, use: :scoped, scope: :group

    has_many :forums, -> {order(name: :asc)}
    belongs_to :group, class_name: '::Group', foreign_key: :group_id

    has_many :category_tags, dependent: :destroy, foreign_key: 'frm_category_id'
    has_many :tags, through: :category_tags, class_name: 'Tag'

    validates :name, presence: true


    validate :visibility

    def to_s
      name
    end


    protected

    def visibility
      self.errors.add(:visible_outside,'Impossibile rendere la sezione privata. Contiene forum pubblici') if !self.visible_outside && self.forums.where(visible_outside: true).exists?
    end
  end
end

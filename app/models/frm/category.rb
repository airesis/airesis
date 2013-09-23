require 'friendly_id'

module Frm
  class Category < Frm::FrmTable
    include ::Concerns::Taggable
    extend FriendlyId
    friendly_id :name, :use => :slugged

    has_many :forums
    belongs_to :group, class_name: '::Group', foreign_key: :group_id

    has_many :category_tags, :dependent => :destroy, foreign_key: 'frm_category_id'
    has_many :tags, :through => :category_tags, :class_name => 'Tag'

    validates :name, :presence => true
    attr_accessible :name


    def to_s
      name
    end

  end
end

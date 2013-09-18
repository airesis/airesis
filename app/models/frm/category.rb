require 'friendly_id'

module Frm
  class Category < Frm::FrmTable

    extend FriendlyId
    friendly_id :name, :use => :slugged

    has_many :forums
    belongs_to :group, class_name: '::Group', foreign_key: :group_id

    validates :name, :presence => true
    attr_accessible :name

    def to_s
      name
    end

  end
end

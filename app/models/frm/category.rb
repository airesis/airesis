require 'friendly_id'

module Frm
  class Category < Frm::FrmTable

    extend FriendlyId
    friendly_id :name, :use => :slugged

    has_many :forums
    validates :name, :presence => true
    attr_accessible :name

    def to_s
      name
    end

  end
end

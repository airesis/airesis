#encoding: utf-8
module Frm
  class TopicProposal < FrmTable
    belongs_to :topic, class_name: 'Frm::Topic', foreign_key: :topic_id
    belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id
  end
end

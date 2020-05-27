class ProposalSection < ApplicationRecord
  belongs_to :proposal, inverse_of: :proposal_sections
  belongs_to :section, inverse_of: :proposal_section, dependent: :destroy
end

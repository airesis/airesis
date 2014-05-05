class  ProposalSection < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :section, dependent: :destroy
end
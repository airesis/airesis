class RevisionSectionHistory < ApplicationRecord
  belongs_to :proposal_revision
  belongs_to :section_history
end

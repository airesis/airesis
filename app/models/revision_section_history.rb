class RevisionSectionHistory < ActiveRecord::Base
  belongs_to :proposal_revision
  belongs_to :section_history
end

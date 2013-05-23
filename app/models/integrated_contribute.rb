class  IntegratedContribute < ActiveRecord::Base
  belongs_to :proposal_revision
  belongs_to :proposal_comment
end
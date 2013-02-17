class GroupInvitationEmail < ActiveRecord::Base

  belongs_to :group
  has_one :group_invitation


end

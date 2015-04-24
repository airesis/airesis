class GroupInvitation < ActiveRecord::Base

  has_many :group_invitation_emails
  belongs_to :inviter, class_name: 'User', foreign_key: :inviter_id
  belongs_to :group

  before_create :build_data

  attr_accessor :emails_list

  protected

  def build_data
    email_array = emails_list.split(',')

    email_array.each do |email|
      next if BannedEmail.find_by(email: email) # check that the user didn't block invitation emails
      next if group.group_invitation_emails.find_by(email: email) # check that he has not been already invited
      next if group.participants.find_by(email: email) # check that he is not already part of the group
      group_invitation_emails.build(email: email)
    end
  end
end

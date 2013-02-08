class GroupInvitation < ActiveRecord::Base

  belongs_to :group_invitation_email
  belongs_to :inviter, :class_name => 'User', :foreign_key => :inviter_id
  belongs_to :invited, :class_name => 'User', :foreign_key => :invited_id

  attr_accessor :emails_list, :group_id

  before_create :generate_token

  protected

  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while GroupInvitation.where(:token => token).exists?
    self.token = token
  end
end

class UserAlert < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :notification, :class_name => 'Notification', :foreign_key => :notification_id


  after_create :increase_counter




  def email_subject
    self.notification.email_subject
  end


  def check!
    self.update_attributes({:checked => true, :checked_at => Time.now})
    if (proposal_id = self.notification.data[:proposal_id])
      ProposalAlert.find_by_proposal_id_and_user_id(proposal_id.to_i, self.user_id).decrement!(:count)
    end
  end


  def self.check_all
    self.update_all({checked: true, checked_at: Time.now})
    self.all.each do |alert|
      if (proposal_id = alert.notification.data[:proposal_id])
        alert = ProposalAlert.find_by_proposal_id_and_user_id(proposal_id.to_i, alert.user_id)
        alert.decrement!(:count) if alert
      end
    end
  end


  protected

  def increase_counter
    @pa = ProposalAlert.find_or_create_by_proposal_id_and_user_id(self.notification.data[:proposal_id].to_i, self.user_id)
    @pa.increment!(:count)
  end
end

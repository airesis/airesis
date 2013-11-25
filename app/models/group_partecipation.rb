class GroupPartecipation < ActiveRecord::Base
  include BlogKitModelHelper, ImageHelper
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :partecipation_role, :class_name => 'PartecipationRole', :foreign_key => :partecipation_role_id
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id, :counter_cache => true
  belongs_to :acceptor, :class_name => 'User', :foreign_key => :acceptor_id

  def self.search(search)
    if search
      partecipations = GroupPartecipation.joins(:user).order(:name)

      #find(:all)
    else
      find(:all)
    end
  end
end

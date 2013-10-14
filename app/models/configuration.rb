class Configuration < ActiveRecord::Base


  SOCIALNETWORK = 'socialnetwork_active'
  RECAPTCHA = 'recaptcha'

  def self.phases_active
    @phases_active = !self.find_by_name('phases_active').value.to_i.zero?
  end

  def self.open_space_proposals
    @open_space_proposals = !self.find_by_name('open_space_proposals').value.to_i.zero?
  end

  def self.socialnetwork_active
    @socialnetwork_active = !self.find_by_name(SOCIALNETWORK).value.to_i.zero?
  end

  def self.elections_active
    @elections_active = !self.find_by_name('elections_active').value.to_i.zero?
  end

  def self.invites_active
    @invites_active = !self.find_by_name('invites_active').value.to_i.zero?
  end

  def self.user_messages
    @user_messages = !self.find_by_name('user_messages').value.to_i.zero?
  end

  def self.groups_calendar
    @groups_calendar = !self.find_by_name('groups_calendar').value.to_i.zero?
  end

  def self.proposal_support
    @proposal_support = !self.find_by_name('proposal_support').value.to_i.zero?
  end

  def self.documents_active
    @documents_active = !self.find_by_name('documents_active').value.to_i.zero?
  end

  def self.group_areas
    @group_areas = !self.find_by_name('group_areas').value.to_i.zero?
  end

  def self.proposal_categories
    @proposal_categories = !self.find_by_name('proposal_categories').value.to_i.zero?
  end

  def self.folksonomy
    @folksonomy = !self.find_by_name('folksonomy').value.to_i.zero?
  end

  def self.rotp
    @rotp = !self.find_by_name('rotp').value.to_i.zero?
  end

  def self.recaptcha
    @rotp = !self.find_by_name(RECAPTCHA).value.to_i.zero?
  end
end

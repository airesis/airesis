class Configuration < ActiveRecord::Base
  SOCIALNETWORK = 'socialnetwork_active'
  RECAPTCHA = 'recaptcha'

  def self.phases_active
    @phases_active = config_active?('phases_active')
  end

  def self.open_space_proposals
    @open_space_proposals = config_active?('open_space_proposals')
  end

  def self.socialnetwork_active
    @socialnetwork_active ||= config_active?(SOCIALNETWORK)
  end

  def self.invites_active
    @invites_active ||= config_active?('invites_active')
  end

  def self.user_messages
    @user_messages ||= config_active?('user_messages')
  end

  def self.groups_calendar
    @groups_calendar ||= config_active?('groups_calendar')
  end

  def self.proposal_support
    @proposal_support ||= config_active?('proposal_support')
  end

  def self.documents_active
    @documents_active ||= config_active?('documents_active')
  end

  def self.group_areas
    @group_areas ||= config_active?('group_areas')
  end

  def self.proposal_categories
    @proposal_categories ||= config_active?('proposal_categories')
  end

  def self.folksonomy
    @folksonomy ||= config_active?('folksonomy')
  end

  def self.rotp
    @rotp ||= config_active?('rotp')
  end

  def self.recaptcha
    @recaptcha ||= config_active?(RECAPTCHA)
  end

  def self.config_active?(name)
    config = find_by(name: name)
    config.present? && !config.value.to_i.zero?
  end
end

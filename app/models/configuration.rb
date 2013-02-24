class Configuration < ActiveRecord::Base
  def self.phases_active
      @phases_active = !self.find_by_name('phases_active').value.to_i.zero?
  end

  def self.open_space_proposals
    @open_space_proposals = !self.find_by_name('open_space_proposals').value.to_i.zero?
  end

  def self.socialnetwork_active
    @socialnetwork_active = !self.find_by_name('socialnetwork_active').value.to_i.zero?
  end

  def self.elections_active
    @elections_active = !self.find_by_name('elections_active').value.to_i.zero?
  end

  def self.invites_active
    @invites_active = !self.find_by_name('invites_active').value.to_i.zero?
  end
end
class AddSocialNetworkVariable < ActiveRecord::Migration
  def up
    Configuration.create(name: 'socialnetwork_active', value: 1)
    Configuration.create(name: 'elections_active', value: 1)
    Configuration.create(name: 'invites_active', value: 1)
  end

  def down
    Configuration.find_by_name("socialnetwork_active").destroy
    Configuration.find_by_name("elections_active").destroy
    Configuration.find_by_name("invites_active").destroy
  end
end

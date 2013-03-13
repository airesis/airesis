class AddSocialNetworkVariable < ActiveRecord::Migration
  def up
    Configuration.create(name: 'socialnetwork_active', value: 1)
    Configuration.create(name: 'elections_active', value: 1)
    Configuration.create(name: 'invites_active', value: 1)
    Configuration.create(name: 'user_messages', value: 1)
    Configuration.create(name: 'groups_calendar', value: 1)
    Configuration.create(name: 'proposal_support', value: 1)
  end

  def down
    Configuration.find_by_name('socialnetwork_active').destroy
    Configuration.find_by_name('elections_active').destroy
    Configuration.find_by_name('invites_active').destroy
    Configuration.find_by_name('groups_calendar').destroy
    Configuration.find_by_name('user_messages').destroy
    Configuration.find_by_name('proposal_support').destroy
  end
end

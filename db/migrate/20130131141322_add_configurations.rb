class AddConfigurations < ActiveRecord::Migration
  def up
    create_table :configurations do |t|
      t.string :name, limit: 100, null: false
      t.string :value,limit: 255, null: false
    end

    Configuration.create(name: 'democracy', value: 1)
    Configuration.create(name: 'default_user_type', value: 1)
    Configuration.create(name: 'groups_active', value: 1)
    Configuration.create(name: 'open_space_calendar', value: 1)
    Configuration.create(name: 'open_space_proposals', value: 1)
    Configuration.create(name: 'blog', value: 1)
    Configuration.create(name: 'phases_active', value: 1)
  end

  def down
    drop_table :configurations
  end
end
